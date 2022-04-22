alter table "public"."keuangan_pembayaran_mahasiswa_others_kwitansi"
           add constraint "keuangan_pembayaran_mahasiswa_others_kwitansi_id_jenis_pemba"
           foreign key ("id_jenis_pembayaran")
           references "public"."keuangan_jenis_pembayaran"
           ("id") on update restrict on delete restrict;
