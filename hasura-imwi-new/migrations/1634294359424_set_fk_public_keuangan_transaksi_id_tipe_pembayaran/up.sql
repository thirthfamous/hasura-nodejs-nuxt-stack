alter table "public"."keuangan_transaksi"
           add constraint "keuangan_transaksi_id_tipe_pembayaran_fkey"
           foreign key ("id_tipe_pembayaran")
           references "public"."keuangan_tipe_pembayaran"
           ("id") on update restrict on delete restrict;
