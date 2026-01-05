import { integer, pgEnum, pgTable, text, timestamp, varchar, boolean, json, numeric, bigint } from "drizzle-orm/pg-core";

/**
 * Core user table backing auth flow.
 */
export const users = pgTable("users", {
  id: integer("id").primaryKey().generatedAlwaysAsIdentity(),
  openId: varchar("openId", { length: 64 }).notNull().unique(),
  name: text("name"),
  email: varchar("email", { length: 320 }),
  loginMethod: varchar("loginMethod", { length: 64 }),
  role: varchar("role", { length: 20 }).default("user").notNull(),
  createdAt: timestamp("createdAt").defaultNow().notNull(),
  updatedAt: timestamp("updatedAt").defaultNow().notNull(),
  lastSignedIn: timestamp("lastSignedIn").defaultNow().notNull(),
});

export type User = typeof users.$inferSelect;
export type InsertUser = typeof users.$inferInsert;

// MPs (Members of Parliament) table
export const mps = pgTable('mps', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  seimasId: varchar('seimas_id', { length: 50 }).notNull().unique(),
  name: varchar('name', { length: 255 }).notNull(),
  party: varchar('party', { length: 255 }).notNull(),
  faction: varchar('faction', { length: 255 }),
  district: varchar('district', { length: 255 }),
  districtNumber: integer('district_number'),
  email: varchar('email', { length: 255 }),
  phone: varchar('phone', { length: 50 }),
  photoUrl: text('photo_url'),
  biography: text('biography'),
  isActive: boolean('is_active').default(true),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// MP Statistics table
export const mpStats = pgTable('mp_stats', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  votingAttendance: numeric('voting_attendance', { precision: 5, scale: 2 }).notNull(),
  partyLoyalty: numeric('party_loyalty', { precision: 5, scale: 2 }).notNull(),
  billsProposed: integer('bills_proposed').default(0),
  billsPassed: integer('bills_passed').default(0),
  accountabilityScore: numeric('accountability_score', { precision: 5, scale: 2 }).notNull(),
  lastCalculated: timestamp('last_calculated').defaultNow(),
});

// Bills table
export const bills = pgTable('bills', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  seimasId: varchar('seimas_id', { length: 50 }).notNull().unique(),
  title: varchar('title', { length: 500 }).notNull(),
  description: text('description'),
  explanatoryNotes: text('explanatory_notes'),
  status: varchar('status', { length: 50 }).notNull(), // draft, proposed, voted, passed, rejected
  category: varchar('category', { length: 100 }),
  submittedAt: timestamp('submitted_at'),
  votedAt: timestamp('voted_at'),
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// Bill Summaries table (AI-generated)
export const billSummaries = pgTable('bill_summaries', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  billId: integer('bill_id').notNull().references(() => bills.id),
  summary: text('summary').notNull(),
  bulletPoints: json('bullet_points').notNull(), // Array of strings
  generatedAt: timestamp('generated_at').defaultNow(),
});

// Bill Sponsors table (many-to-many relationship)
export const billSponsors = pgTable('bill_sponsors', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  billId: integer('bill_id').notNull().references(() => bills.id),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  isPrimary: boolean('is_primary').default(false),
});

// Votes table
export const votes = pgTable('votes', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  billId: integer('bill_id').notNull().references(() => bills.id),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  voteValue: varchar('vote_value', { length: 20 }).notNull(), // for, against, abstain, absent
  votedAt: timestamp('voted_at').defaultNow(),
});

// Quiz Questions table
export const quizQuestions = pgTable('quiz_questions', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  billId: integer('bill_id').references(() => bills.id),
  questionText: text('question_text').notNull(),
  category: varchar('category', { length: 100 }),
  createdAt: timestamp('created_at').defaultNow(),
});

// Quiz Answers table (MP positions on quiz questions)
export const quizAnswers = pgTable('quiz_answers', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  questionId: integer('question_id').notNull().references(() => quizQuestions.id),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  answer: varchar('answer', { length: 20 }).notNull(), // agree, disagree, neutral
});

// User Quiz Results table (for storing user quiz responses)
export const userQuizResults = pgTable('user_quiz_results', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  sessionId: varchar('session_id', { length: 100 }).notNull(),
  questionId: integer('question_id').notNull().references(() => quizQuestions.id),
  userAnswer: varchar('user_answer', { length: 20 }).notNull(),
  createdAt: timestamp('created_at').defaultNow(),
});

// Committees table
export const committees = pgTable('committees', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  name: varchar('name', { length: 255 }).notNull(),
  description: text('description'),
  createdAt: timestamp('created_at').defaultNow(),
});

// Committee Members table (many-to-many)
export const committeeMembers = pgTable('committee_members', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  committeeId: integer('committee_id').notNull().references(() => committees.id),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  role: varchar('role', { length: 100 }), // chair, member, etc.
  joinedAt: timestamp('joined_at').defaultNow(),
});

// Accountability Flags table
export const accountabilityFlags = pgTable('accountability_flags', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  flagType: varchar('flag_type', { length: 100 }).notNull(), // high_absence, voting_inconsistency, party_flip, etc.
  severity: varchar('severity', { length: 20 }).notNull(), // low, medium, high
  title: varchar('title', { length: 255 }).notNull(),
  description: text('description').notNull(),
  detectedAt: timestamp('detected_at').defaultNow(),
  resolved: boolean('resolved').default(false),
});

// User Follows table (for notification system)
export const userFollows = pgTable('user_follows', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  userId: varchar('user_id', { length: 100 }).notNull(),
  mpId: integer('mp_id').references(() => mps.id),
  billId: integer('bill_id').references(() => bills.id),
  topic: varchar('topic', { length: 100 }),
  createdAt: timestamp('created_at').defaultNow(),
});

// MP Assistants table
export const mpAssistants = pgTable('mp_assistants', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  name: varchar('name', { length: 255 }).notNull(),
  role: varchar('role', { length: 255 }),
  phone: varchar('phone', { length: 50 }),
  email: varchar('email', { length: 255 }),
  createdAt: timestamp('created_at').defaultNow(),
});

// MP Business Trips table
export const mpTrips = pgTable('mp_trips', {
  id: integer('id').primaryKey().generatedAlwaysAsIdentity(),
  mpId: integer('mp_id').notNull().references(() => mps.id),
  destination: varchar('destination', { length: 255 }).notNull(),
  purpose: text('purpose'),
  startDate: timestamp('start_date'),
  endDate: timestamp('end_date'),
  cost: numeric('cost', { precision: 10, scale: 2 }),
  createdAt: timestamp('created_at').defaultNow(),
});
