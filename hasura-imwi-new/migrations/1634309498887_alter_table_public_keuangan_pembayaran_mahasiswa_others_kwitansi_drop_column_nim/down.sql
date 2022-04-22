ALTER TABLE "public"."keuangan_pembayaran_mahasiswa_others_kwitansi" ADD COLUMN "nim" text;
ALTER TABLE "public"."keuangan_pembayaran_mahasiswa_others_kwitansi" ALTER COLUMN "nim" DROP NOT NULL;
