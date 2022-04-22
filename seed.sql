INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(1, 'Angkatan', NULL, '/angkatan', 8);
INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(2, 'Mahasiswa', '', '/mahasiswa', 8);
INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(3, 'Setting Pembayaran', '', '/setting-pembayaran', 8);
INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(4, 'SPP DPP', '', '/spp-dpp', 7);
INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(5, 'Tahun Ajar', '', '/tahunajar', 8);
INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(6, 'Universitas', '', '/universitas', 8);
INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(7, 'Billing', NULL, NULL, NULL);
INSERT INTO public.navigation
(id, nama, icon, link, id_parent)
VALUES(8, 'Master Data', NULL, NULL, NULL);

INSERT INTO public."role"
(id, "name")
VALUES(2, 'keuangan');
INSERT INTO public."role"
(id, "name")
VALUES(3, 'akademik');
INSERT INTO public."role"
(id, "name")
VALUES(1, 'admin');

INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(1, 1, 1);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(2, 1, 2);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(3, 1, 3);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(4, 1, 4);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(5, 1, 5);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(6, 1, 6);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(7, 1, 7);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(8, 1, 8);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(13, 2, 7);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(14, 2, 4);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(15, 2, 8);
INSERT INTO public.role_navigation
(id, id_role, id_navigation)
VALUES(16, 2, 3);

INSERT INTO public.master_universitas
(id, nama, alamat, kode_pos, telp, provinsi, kota, kecamatan, kelurahan, email, website, created_at, updated_at, last_updated_by)
VALUES(1, 'IMWI', 'Jln Masjid', '43212', '082938291', 'Jawa Barat', 'Kota Sukabumi', 'Cikole', 'Cikole', 'hallo@imwi.ac.id', 'imwi.ac.id', '2021-10-12 21:09:24.835', '2021-10-12 21:09:24.835', NULL);

INSERT INTO public.keuangan_balance
(id, balance)
VALUES(1, 0);

INSERT INTO public.keuangan_jenis_pembayaran
(id, nama)
VALUES(1, 'Cash');
INSERT INTO public.keuangan_jenis_pembayaran
(id, nama)
VALUES(2, 'Transfer');

INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(1, 'SPP/DPP', '2021-10-15 17:32:57.902', '2021-10-15 17:32:57.902', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(2, 'Pendaftaran', '2021-10-15 17:33:38.575', '2021-10-15 17:33:38.575', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(3, 'Jas Almamater', '2021-10-15 17:33:45.631', '2021-10-15 17:33:45.631', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(4, 'Kemahasiswaan', '2021-10-15 17:33:53.900', '2021-10-15 17:33:53.900', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(5, 'Ujikom', '2021-10-15 17:33:59.762', '2021-10-15 17:33:59.762', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(6, 'EPT', '2021-10-15 17:34:04.933', '2021-10-15 17:34:04.933', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(7, 'SUP', '2021-10-15 17:34:08.282', '2021-10-15 17:34:08.282', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(8, 'Bimbingan', '2021-10-15 17:34:12.251', '2021-10-15 17:34:12.251', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(9, 'Sidang Skripsi', '2021-10-15 17:34:18.020', '2021-10-15 17:34:18.020', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(10, 'Wisuda', '2021-10-15 17:34:21.911', '2021-10-15 17:34:21.911', 2);
INSERT INTO public.keuangan_tipe_pembayaran
(id, nama, created_at, updated_at, "type")
VALUES(11, 'Debit Lain-lain', '2021-10-15 18:13:22.452', '2021-10-15 18:13:22.452', 2);


INSERT INTO public.user_karyawan
(id, "name", email, "password", created_at, updated_at, username)
VALUES('d670e484-c562-4625-af62-b2d43cca7bca', 'Harja Mulyanto', 'harja@gmail.com', '$2y$10$ILNJN9oCUdJdIKgu67it2OUbCwEhopUtJdOt963bAE0JyFA.Gb7OC', '2021-10-12 20:59:09.615', '2021-10-14 12:15:05.150', 'harja');

INSERT INTO public.user_karyawan_role
(id, id_user_karyawan, id_role)
VALUES(2, 'd670e484-c562-4625-af62-b2d43cca7bca', 2);
