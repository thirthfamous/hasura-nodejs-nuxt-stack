alter table "public"."keuangan_pembayaran_mahasiswa_others_kwitansi"
           add constraint "keuangan_pembayaran_mahasiswa_others_kwitansi_id_mahasiswa_f"
           foreign key ("id_mahasiswa")
           references "public"."mahasiswa"
           ("id") on update restrict on delete restrict;
