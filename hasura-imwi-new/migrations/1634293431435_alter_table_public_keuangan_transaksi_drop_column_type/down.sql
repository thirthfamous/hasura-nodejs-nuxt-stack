ALTER TABLE "public"."keuangan_transaksi" ADD COLUMN "type" int4;
ALTER TABLE "public"."keuangan_transaksi" ALTER COLUMN "type" DROP NOT NULL;
COMMENT ON COLUMN "public"."keuangan_transaksi"."type" IS E'1 = Kredit, 2 = Debit';
