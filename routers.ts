import { COOKIE_NAME } from "@shared/const";
import { getSessionCookieOptions } from "./_core/cookies";
import { systemRouter } from "./_core/systemRouter";
import { publicProcedure, router, protectedProcedure } from "./_core/trpc";
import { z } from "zod";
import * as db from "./db";

export const appRouter = router({
    // if you need to use socket.io, read and register route in server/_core/index.ts, all api should start with '/api/' so that the gateway can route correctly
  system: systemRouter,
  auth: router({
    me: publicProcedure.query(opts => opts.ctx.user),
    logout: publicProcedure.mutation(({ ctx }) => {
      const cookieOptions = getSessionCookieOptions(ctx.req);
      ctx.res.clearCookie(COOKIE_NAME, { ...cookieOptions, maxAge: -1 });
      return {
        success: true,
      } as const;
    }),
  }),

  // MPs router
  mps: router({
    list: publicProcedure
      .input(z.object({
        party: z.string().optional(),
        isActive: z.boolean().optional(),
      }).optional())
      .query(async ({ input }) => {
        return await db.getAllMps(input);
      }),
    
    byId: publicProcedure
      .input(z.object({ id: z.number() }))
      .query(async ({ input }) => {
        return await db.getMpById(input.id);
      }),
    
    search: publicProcedure
      .input(z.object({ term: z.string() }))
      .query(async ({ input }) => {
        return await db.searchMps(input.term);
      }),
    
    stats: publicProcedure
      .input(z.object({ mpId: z.number() }))
      .query(async ({ input }) => {
        return await db.getMpStats(input.mpId);
      }),
  }),

  // Bills router
  bills: router({
    list: publicProcedure
      .input(z.object({
        status: z.string().optional(),
        category: z.string().optional(),
      }).optional())
      .query(async ({ input }) => {
        return await db.getAllBills(input);
      }),
    
    byId: publicProcedure
      .input(z.object({ id: z.number() }))
      .query(async ({ input }) => {
        return await db.getBillById(input.id);
      }),
  }),

  // Votes router
  votes: router({
    byMp: publicProcedure
      .input(z.object({ 
        mpId: z.number(),
        limit: z.number().optional(),
      }))
      .query(async ({ input }) => {
        return await db.getVotesByMpId(input.mpId, input.limit);
      }),
    
    byBill: publicProcedure
      .input(z.object({ billId: z.number() }))
      .query(async ({ input }) => {
        return await db.getVotesByBillId(input.billId);
      }),
  }),

  // Quiz router
  quiz: router({
    questions: publicProcedure.query(async () => {
      return await db.getAllQuizQuestions();
    }),
    
    mpAnswers: publicProcedure
      .input(z.object({ mpId: z.number() }))
      .query(async ({ input }) => {
        return await db.getQuizAnswersByMpId(input.mpId);
      }),
    
    saveResult: publicProcedure
      .input(z.object({
        sessionId: z.string(),
        questionId: z.number(),
        userAnswer: z.string(),
      }))
      .mutation(async ({ input }) => {
        await db.saveUserQuizResult(input);
        return { success: true };
      }),
    
    results: publicProcedure
      .input(z.object({ sessionId: z.string() }))
      .query(async ({ input }) => {
        return await db.getUserQuizResults(input.sessionId);
      }),
  }),
});

export type AppRouter = typeof appRouter;
