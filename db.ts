import { eq } from "drizzle-orm";
import { drizzle } from "drizzle-orm/postgres-js";
import postgres from "postgres";
import { InsertUser, users } from "../drizzle/schema";
import { ENV } from './_core/env';

let _db: ReturnType<typeof drizzle> | null = null;

// Lazily create the drizzle instance so local tooling can run without a DB.
export async function getDb() {
  if (!_db && process.env.DATABASE_URL) {
    try {
      const client = postgres(process.env.DATABASE_URL);
      _db = drizzle(client);
    } catch (error) {
      console.warn("[Database] Failed to connect:", error);
      _db = null;
    }
  }
  return _db;
}

export async function upsertUser(user: InsertUser): Promise<void> {
  if (!user.openId) {
    throw new Error("User openId is required for upsert");
  }

  const db = await getDb();
  if (!db) {
    console.warn("[Database] Cannot upsert user: database not available");
    return;
  }

  try {
    const values: InsertUser = {
      openId: user.openId,
    };
    const updateSet: Record<string, unknown> = {};

    const textFields = ["name", "email", "loginMethod"] as const;
    type TextField = (typeof textFields)[number];

    const assignNullable = (field: TextField) => {
      const value = user[field];
      if (value === undefined) return;
      const normalized = value ?? null;
      values[field] = normalized;
      updateSet[field] = normalized;
    };

    textFields.forEach(assignNullable);

    if (user.lastSignedIn !== undefined) {
      values.lastSignedIn = user.lastSignedIn;
      updateSet.lastSignedIn = user.lastSignedIn;
    }
    if (user.role !== undefined) {
      values.role = user.role;
      updateSet.role = user.role;
    } else if (user.openId === ENV.ownerOpenId) {
      values.role = 'admin';
      updateSet.role = 'admin';
    }

    if (!values.lastSignedIn) {
      values.lastSignedIn = new Date();
    }

    if (Object.keys(updateSet).length === 0) {
      updateSet.lastSignedIn = new Date();
    }

    await db.insert(users).values(values).onConflictDoUpdate({
      target: users.openId,
      set: updateSet,
    });
  } catch (error) {
    console.error("[Database] Failed to upsert user:", error);
    throw error;
  }
}

export async function getUserByOpenId(openId: string) {
  const db = await getDb();
  if (!db) {
    console.warn("[Database] Cannot get user: database not available");
    return undefined;
  }

  const result = await db.select().from(users).where(eq(users.openId, openId)).limit(1);

  return result.length > 0 ? result[0] : undefined;
}

// TODO: add feature queries here as your schema grows.

import { mps, bills, votes, mpStats, quizQuestions, quizAnswers, userQuizResults } from "../drizzle/schema";
import { desc, and, sql } from "drizzle-orm";

// ==================== MP Queries ====================

export async function getAllMps(filters?: { party?: string; isActive?: boolean }) {
  const db = await getDb();
  if (!db) return [];

  let query = db.select().from(mps);
  
  const conditions = [];
  if (filters?.party) {
    conditions.push(eq(mps.party, filters.party));
  }
  if (filters?.isActive !== undefined) {
    conditions.push(eq(mps.isActive, filters.isActive));
  }

  if (conditions.length > 0) {
    query = query.where(and(...conditions)) as any;
  }

  return await query;
}

export async function getMpById(id: number) {
  const db = await getDb();
  if (!db) return undefined;

  const result = await db.select().from(mps).where(eq(mps.id, id)).limit(1);
  return result.length > 0 ? result[0] : undefined;
}

export async function getMpBySeimasId(seimasId: string) {
  const db = await getDb();
  if (!db) return undefined;

  const result = await db.select().from(mps).where(eq(mps.seimasId, seimasId)).limit(1);
  return result.length > 0 ? result[0] : undefined;
}

export async function searchMps(searchTerm: string) {
  const db = await getDb();
  if (!db) return [];

  return await db.select().from(mps).where(
    sql`${mps.name} LIKE ${`%${searchTerm}%`} OR ${mps.party} LIKE ${`%${searchTerm}%`}`
  );
}

// ==================== MP Statistics Queries ====================

export async function getMpStats(mpId: number) {
  const db = await getDb();
  if (!db) return undefined;

  const result = await db.select().from(mpStats).where(eq(mpStats.mpId, mpId)).limit(1);
  return result.length > 0 ? result[0] : undefined;
}

export async function upsertMpStats(stats: typeof mpStats.$inferInsert) {
  const db = await getDb();
  if (!db) return;

  await db.insert(mpStats).values(stats).onConflictDoUpdate({
    target: mpStats.mpId,
    set: {
      votingAttendance: stats.votingAttendance,
      partyLoyalty: stats.partyLoyalty,
      billsProposed: stats.billsProposed,
      billsPassed: stats.billsPassed,
      accountabilityScore: stats.accountabilityScore,
      lastCalculated: new Date(),
    },
  });
}

// ==================== Bill Queries ====================

export async function getAllBills(filters?: { status?: string; category?: string }) {
  const db = await getDb();
  if (!db) return [];

  let query = db.select().from(bills).orderBy(desc(bills.createdAt));
  
  const conditions = [];
  if (filters?.status) {
    conditions.push(eq(bills.status, filters.status));
  }
  if (filters?.category) {
    conditions.push(eq(bills.category, filters.category));
  }

  if (conditions.length > 0) {
    query = query.where(and(...conditions)) as any;
  }

  return await query;
}

export async function getBillById(id: number) {
  const db = await getDb();
  if (!db) return undefined;

  const result = await db.select().from(bills).where(eq(bills.id, id)).limit(1);
  return result.length > 0 ? result[0] : undefined;
}

// ==================== Vote Queries ====================

export async function getVotesByMpId(mpId: number, limit: number = 50) {
  const db = await getDb();
  if (!db) return [];

  return await db
    .select({
      vote: votes,
      bill: bills,
    })
    .from(votes)
    .leftJoin(bills, eq(votes.billId, bills.id))
    .where(eq(votes.mpId, mpId))
    .orderBy(desc(votes.votedAt))
    .limit(limit);
}

export async function getVotesByBillId(billId: number) {
  const db = await getDb();
  if (!db) return [];

  return await db
    .select({
      vote: votes,
      mp: mps,
    })
    .from(votes)
    .leftJoin(mps, eq(votes.mpId, mps.id))
    .where(eq(votes.billId, billId));
}

// ==================== Quiz Queries ====================

export async function getAllQuizQuestions() {
  const db = await getDb();
  if (!db) return [];

  return await db.select().from(quizQuestions);
}

export async function getQuizAnswersByMpId(mpId: number) {
  const db = await getDb();
  if (!db) return [];

  return await db
    .select({
      answer: quizAnswers,
      question: quizQuestions,
    })
    .from(quizAnswers)
    .leftJoin(quizQuestions, eq(quizAnswers.questionId, quizQuestions.id))
    .where(eq(quizAnswers.mpId, mpId));
}

export async function saveUserQuizResult(result: typeof userQuizResults.$inferInsert) {
  const db = await getDb();
  if (!db) return;

  await db.insert(userQuizResults).values(result);
}

export async function getUserQuizResults(sessionId: string) {
  const db = await getDb();
  if (!db) return [];

  return await db
    .select()
    .from(userQuizResults)
    .where(eq(userQuizResults.sessionId, sessionId));
}
