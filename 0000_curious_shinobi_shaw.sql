CREATE TABLE "accountability_flags" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "accountability_flags_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"mp_id" integer NOT NULL,
	"flag_type" varchar(100) NOT NULL,
	"severity" varchar(20) NOT NULL,
	"title" varchar(255) NOT NULL,
	"description" text NOT NULL,
	"detected_at" timestamp DEFAULT now(),
	"resolved" boolean DEFAULT false
);
--> statement-breakpoint
CREATE TABLE "bill_sponsors" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "bill_sponsors_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"bill_id" integer NOT NULL,
	"mp_id" integer NOT NULL,
	"is_primary" boolean DEFAULT false
);
--> statement-breakpoint
CREATE TABLE "bill_summaries" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "bill_summaries_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"bill_id" integer NOT NULL,
	"summary" text NOT NULL,
	"bullet_points" json NOT NULL,
	"generated_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "bills" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "bills_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"seimas_id" varchar(50) NOT NULL,
	"title" varchar(500) NOT NULL,
	"description" text,
	"explanatory_notes" text,
	"status" varchar(50) NOT NULL,
	"category" varchar(100),
	"submitted_at" timestamp,
	"voted_at" timestamp,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	CONSTRAINT "bills_seimas_id_unique" UNIQUE("seimas_id")
);
--> statement-breakpoint
CREATE TABLE "committee_members" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "committee_members_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"committee_id" integer NOT NULL,
	"mp_id" integer NOT NULL,
	"role" varchar(100),
	"joined_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "committees" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "committees_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"name" varchar(255) NOT NULL,
	"description" text,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "mp_stats" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "mp_stats_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"mp_id" integer NOT NULL,
	"voting_attendance" numeric(5, 2) NOT NULL,
	"party_loyalty" numeric(5, 2) NOT NULL,
	"bills_proposed" integer DEFAULT 0,
	"bills_passed" integer DEFAULT 0,
	"accountability_score" numeric(5, 2) NOT NULL,
	"last_calculated" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "mps" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "mps_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"seimas_id" varchar(50) NOT NULL,
	"name" varchar(255) NOT NULL,
	"party" varchar(255) NOT NULL,
	"faction" varchar(255),
	"district" varchar(255),
	"district_number" integer,
	"email" varchar(255),
	"phone" varchar(50),
	"photo_url" text,
	"biography" text,
	"is_active" boolean DEFAULT true,
	"created_at" timestamp DEFAULT now(),
	"updated_at" timestamp DEFAULT now(),
	CONSTRAINT "mps_seimas_id_unique" UNIQUE("seimas_id")
);
--> statement-breakpoint
CREATE TABLE "quiz_answers" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "quiz_answers_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"question_id" integer NOT NULL,
	"mp_id" integer NOT NULL,
	"answer" varchar(20) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "quiz_questions" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "quiz_questions_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"bill_id" integer,
	"question_text" text NOT NULL,
	"category" varchar(100),
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "user_follows" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "user_follows_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"user_id" varchar(100) NOT NULL,
	"mp_id" integer,
	"bill_id" integer,
	"topic" varchar(100),
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "user_quiz_results" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "user_quiz_results_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"session_id" varchar(100) NOT NULL,
	"question_id" integer NOT NULL,
	"user_answer" varchar(20) NOT NULL,
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "users" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "users_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"openId" varchar(64) NOT NULL,
	"name" text,
	"email" varchar(320),
	"loginMethod" varchar(64),
	"role" varchar(20) DEFAULT 'user' NOT NULL,
	"createdAt" timestamp DEFAULT now() NOT NULL,
	"updatedAt" timestamp DEFAULT now() NOT NULL,
	"lastSignedIn" timestamp DEFAULT now() NOT NULL,
	CONSTRAINT "users_openId_unique" UNIQUE("openId")
);
--> statement-breakpoint
CREATE TABLE "votes" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "votes_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"bill_id" integer NOT NULL,
	"mp_id" integer NOT NULL,
	"vote_value" varchar(20) NOT NULL,
	"voted_at" timestamp DEFAULT now()
);
--> statement-breakpoint
ALTER TABLE "accountability_flags" ADD CONSTRAINT "accountability_flags_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bill_sponsors" ADD CONSTRAINT "bill_sponsors_bill_id_bills_id_fk" FOREIGN KEY ("bill_id") REFERENCES "public"."bills"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bill_sponsors" ADD CONSTRAINT "bill_sponsors_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "bill_summaries" ADD CONSTRAINT "bill_summaries_bill_id_bills_id_fk" FOREIGN KEY ("bill_id") REFERENCES "public"."bills"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "committee_members" ADD CONSTRAINT "committee_members_committee_id_committees_id_fk" FOREIGN KEY ("committee_id") REFERENCES "public"."committees"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "committee_members" ADD CONSTRAINT "committee_members_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "mp_stats" ADD CONSTRAINT "mp_stats_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "quiz_answers" ADD CONSTRAINT "quiz_answers_question_id_quiz_questions_id_fk" FOREIGN KEY ("question_id") REFERENCES "public"."quiz_questions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "quiz_answers" ADD CONSTRAINT "quiz_answers_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "quiz_questions" ADD CONSTRAINT "quiz_questions_bill_id_bills_id_fk" FOREIGN KEY ("bill_id") REFERENCES "public"."bills"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_follows" ADD CONSTRAINT "user_follows_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_follows" ADD CONSTRAINT "user_follows_bill_id_bills_id_fk" FOREIGN KEY ("bill_id") REFERENCES "public"."bills"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "user_quiz_results" ADD CONSTRAINT "user_quiz_results_question_id_quiz_questions_id_fk" FOREIGN KEY ("question_id") REFERENCES "public"."quiz_questions"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "votes" ADD CONSTRAINT "votes_bill_id_bills_id_fk" FOREIGN KEY ("bill_id") REFERENCES "public"."bills"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "votes" ADD CONSTRAINT "votes_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;