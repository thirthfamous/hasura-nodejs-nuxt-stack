alter table "public"."keuangan_pembayaran_mahasiswa"
           add constraint "keuangan_pembayaran_mahasiswa_created_by_fkey"
           foreign key ("created_by")
           references "public"."user_karyawan"
           ("id") on update restrict on delete restrict;
