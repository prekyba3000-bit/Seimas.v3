CREATE TABLE "mp_assistants" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "mp_assistants_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"mp_id" integer NOT NULL,
	"name" varchar(255) NOT NULL,
	"role" varchar(255),
	"phone" varchar(50),
	"email" varchar(255),
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
CREATE TABLE "mp_trips" (
	"id" integer PRIMARY KEY GENERATED ALWAYS AS IDENTITY (sequence name "mp_trips_id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1),
	"mp_id" integer NOT NULL,
	"destination" varchar(255) NOT NULL,
	"purpose" text,
	"start_date" timestamp,
	"end_date" timestamp,
	"cost" numeric(10, 2),
	"created_at" timestamp DEFAULT now()
);
--> statement-breakpoint
ALTER TABLE "mp_assistants" ADD CONSTRAINT "mp_assistants_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "mp_trips" ADD CONSTRAINT "mp_trips_mp_id_mps_id_fk" FOREIGN KEY ("mp_id") REFERENCES "public"."mps"("id") ON DELETE no action ON UPDATE no action;