CREATE FUNCTION public.set_current_timestamp_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  _new record;
BEGIN
  _new := NEW;
  _new."updated_at" = NOW();
  RETURN _new;
END;
$$;
CREATE TABLE public.angkatan (
    id integer NOT NULL,
    name text NOT NULL,
    deskripsi text
);
CREATE SEQUENCE public.angkatan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.angkatan_id_seq OWNED BY public.angkatan.id;
CREATE TABLE public.kelas (
    kode text NOT NULL,
    is_karyawan boolean NOT NULL
);
CREATE TABLE public.keuangan_jenis_pembayaran (
    id integer NOT NULL,
    nama text NOT NULL
);
CREATE SEQUENCE public.keuangan_jenis_pembayaran_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.keuangan_jenis_pembayaran_id_seq OWNED BY public.keuangan_jenis_pembayaran.id;
CREATE TABLE public.keuangan_pembayaran_mahasiswa (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    id_mahasiswa integer NOT NULL,
    cara_pembayaran integer NOT NULL,
    total_cicilan integer,
    is_dpp_full boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid
);
COMMENT ON COLUMN public.keuangan_pembayaran_mahasiswa.cara_pembayaran IS '1 = per semester. 2 = per cicilan';
COMMENT ON COLUMN public.keuangan_pembayaran_mahasiswa.is_dpp_full IS 'true = full dpp, spp biasa. false = dpp ke spp in';
CREATE TABLE public.keuangan_pembayaran_mahasiswa_kwitansi (
    id integer NOT NULL,
    id_pembayaran_mahasiswa_rincian integer NOT NULL,
    jumlah integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    catatan text,
    id_jenis_pembayaran integer NOT NULL
);
COMMENT ON TABLE public.keuangan_pembayaran_mahasiswa_kwitansi IS 'kwitansi pembayaran dpp spp mahasiswa';
CREATE SEQUENCE public.keuangan_pembayaran_mahasiswa_kwitansi_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.keuangan_pembayaran_mahasiswa_kwitansi_id_seq OWNED BY public.keuangan_pembayaran_mahasiswa_kwitansi.id;
CREATE TABLE public.keuangan_pembayaran_mahasiswa_rincian (
    id integer NOT NULL,
    id_pembayaran_mahasiswa uuid NOT NULL,
    nama_pembayaran text NOT NULL,
    waktu_pembayaran date NOT NULL,
    jumlah_pembayaran integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by uuid,
    is_lunas boolean DEFAULT false NOT NULL
);
COMMENT ON COLUMN public.keuangan_pembayaran_mahasiswa_rincian.jumlah_pembayaran IS 'sisa pembayaran';
CREATE SEQUENCE public.keuangan_pembayaran_mahasiswa_rincian_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.keuangan_pembayaran_mahasiswa_rincian_id_seq OWNED BY public.keuangan_pembayaran_mahasiswa_rincian.id;
CREATE TABLE public.keuangan_tipe_pembayaran (
    id integer NOT NULL,
    nama text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.keuangan_tipe_pembayaran_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.keuangan_tipe_pembayaran_id_seq OWNED BY public.keuangan_tipe_pembayaran.id;
CREATE TABLE public.mahasiswa (
    id integer NOT NULL,
    nim text NOT NULL,
    password text NOT NULL,
    nama text,
    id_jenis_kelamin integer,
    nisn text,
    tempat_lahir text,
    tanggal_lahir date,
    nik text,
    id_agama integer,
    kebutuhan_khusus text,
    alamat text,
    rt text,
    rw text,
    dusun text,
    kelurahan text,
    kecamatan text,
    kode_pos integer,
    jenis_tinggal text,
    alat_transportasi text,
    telepon text,
    hp text,
    email text,
    skhun text,
    penerima_kps text,
    no_kps text,
    foto text,
    nama_ayah text,
    tahun_lahir_ayah integer,
    pendidikan_ayah text,
    pekerjaan_ayah text,
    penghasilan_ayah text,
    kebutuhan_khusus_ayah text,
    no_telpon_ayah text,
    nama_ibu text,
    tahun_lahir_ibu integer,
    pendidikan_ibu text,
    pekerjaan_ibu text,
    penghasilan_ibu text,
    kebutuhan_khusus_ibu text,
    no_telpon_ibu text,
    nama_wali text,
    tahun_lahir_wali integer,
    pendidikan_wali text,
    pekerjaan_wali text,
    penghasilan_wali text,
    id_angkatan integer,
    status_awal text,
    status_siswa text,
    tingkat text,
    kode_kelas text,
    kode_jurusan uuid,
    id_sesi integer,
    no_transkrip text,
    no_ijazah text,
    pin text,
    th_masuk integer,
    tgl_lulus date,
    sts integer,
    t_akademik text,
    ipk double precision,
    kelas text,
    th_lulus integer,
    tgl_sidang date,
    is_karyawan boolean DEFAULT false NOT NULL
);
CREATE TABLE public.mahasiswa_pakai_sistem (
    id integer NOT NULL,
    id_mahasiswa integer NOT NULL,
    sampai_tanggal date NOT NULL,
    created_by uuid,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE SEQUENCE public.mahasiswa_pakai_sistem_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.mahasiswa_pakai_sistem_id_seq OWNED BY public.mahasiswa_pakai_sistem.id;
CREATE TABLE public.master_fakultas (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    nama text NOT NULL,
    deskripsi text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
CREATE TABLE public.master_prodi (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    id_fakultas uuid NOT NULL,
    nama text NOT NULL,
    deskripsi text NOT NULL,
    kode text NOT NULL,
    nama_en text NOT NULL
);
CREATE TABLE public.master_universitas (
    id integer NOT NULL,
    nama text,
    alamat text,
    kode_pos text,
    telp text,
    provinsi text,
    kota text,
    kecamatan text,
    kelurahan text,
    email text,
    website text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_updated_by uuid
);
CREATE SEQUENCE public.master_universitas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.master_universitas_id_seq OWNED BY public.master_universitas.id;
CREATE TABLE public.navigation (
    id integer NOT NULL,
    nama text NOT NULL,
    icon text,
    link text,
    id_parent integer
);
CREATE SEQUENCE public.navigation_parent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.navigation_parent_id_seq OWNED BY public.navigation.id;
CREATE TABLE public.role (
    id integer NOT NULL,
    name text NOT NULL
);
CREATE SEQUENCE public.role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.role_id_seq OWNED BY public.role.id;
CREATE TABLE public.role_navigation (
    id integer NOT NULL,
    id_role integer NOT NULL,
    id_navigation integer NOT NULL
);
CREATE SEQUENCE public.role_navigation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.role_navigation_id_seq OWNED BY public.role_navigation.id;
CREATE TABLE public.setting_pembayaran (
    id integer NOT NULL,
    id_angkatan integer NOT NULL,
    id_jurusan uuid NOT NULL,
    is_karyawan boolean NOT NULL,
    biaya_dpp integer NOT NULL,
    biaya_spp integer NOT NULL
);
CREATE SEQUENCE public.setting_pembayaran_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.setting_pembayaran_id_seq OWNED BY public.setting_pembayaran.id;
CREATE TABLE public.tahun_ajar (
    id integer NOT NULL,
    name text NOT NULL
);
CREATE SEQUENCE public.tahun_ajar_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.tahun_ajar_id_seq OWNED BY public.tahun_ajar.id;
CREATE TABLE public.user_karyawan (
    id uuid DEFAULT public.gen_random_uuid() NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    username text NOT NULL
);
COMMENT ON TABLE public.user_karyawan IS 'This is about user karyawan table';
CREATE TABLE public.user_karyawan_role (
    id integer NOT NULL,
    id_user_karyawan uuid NOT NULL,
    id_role integer NOT NULL
);
CREATE SEQUENCE public.user_karyawan_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.user_karyawan_role_id_seq OWNED BY public.user_karyawan_role.id;
ALTER TABLE ONLY public.angkatan ALTER COLUMN id SET DEFAULT nextval('public.angkatan_id_seq'::regclass);
ALTER TABLE ONLY public.keuangan_jenis_pembayaran ALTER COLUMN id SET DEFAULT nextval('public.keuangan_jenis_pembayaran_id_seq'::regclass);
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_kwitansi ALTER COLUMN id SET DEFAULT nextval('public.keuangan_pembayaran_mahasiswa_kwitansi_id_seq'::regclass);
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_rincian ALTER COLUMN id SET DEFAULT nextval('public.keuangan_pembayaran_mahasiswa_rincian_id_seq'::regclass);
ALTER TABLE ONLY public.keuangan_tipe_pembayaran ALTER COLUMN id SET DEFAULT nextval('public.keuangan_tipe_pembayaran_id_seq'::regclass);
ALTER TABLE ONLY public.mahasiswa_pakai_sistem ALTER COLUMN id SET DEFAULT nextval('public.mahasiswa_pakai_sistem_id_seq'::regclass);
ALTER TABLE ONLY public.master_universitas ALTER COLUMN id SET DEFAULT nextval('public.master_universitas_id_seq'::regclass);
ALTER TABLE ONLY public.navigation ALTER COLUMN id SET DEFAULT nextval('public.navigation_parent_id_seq'::regclass);
ALTER TABLE ONLY public.role ALTER COLUMN id SET DEFAULT nextval('public.role_id_seq'::regclass);
ALTER TABLE ONLY public.role_navigation ALTER COLUMN id SET DEFAULT nextval('public.role_navigation_id_seq'::regclass);
ALTER TABLE ONLY public.setting_pembayaran ALTER COLUMN id SET DEFAULT nextval('public.setting_pembayaran_id_seq'::regclass);
ALTER TABLE ONLY public.tahun_ajar ALTER COLUMN id SET DEFAULT nextval('public.tahun_ajar_id_seq'::regclass);
ALTER TABLE ONLY public.user_karyawan_role ALTER COLUMN id SET DEFAULT nextval('public.user_karyawan_role_id_seq'::regclass);
ALTER TABLE ONLY public.angkatan
    ADD CONSTRAINT angkatan_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.kelas
    ADD CONSTRAINT kelas_pkey PRIMARY KEY (kode);
ALTER TABLE ONLY public.keuangan_jenis_pembayaran
    ADD CONSTRAINT keuangan_jenis_pembayaran_nama_key UNIQUE (nama);
ALTER TABLE ONLY public.keuangan_jenis_pembayaran
    ADD CONSTRAINT keuangan_jenis_pembayaran_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_kwitansi
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_kwitansi_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_rincian
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_rincian_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.keuangan_tipe_pembayaran
    ADD CONSTRAINT keuangan_tipe_pembayaran_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.mahasiswa_pakai_sistem
    ADD CONSTRAINT mahasiswa_pakai_sistem_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.mahasiswa
    ADD CONSTRAINT mahasiswa_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.master_fakultas
    ADD CONSTRAINT master_fakultas_nama_key UNIQUE (nama);
ALTER TABLE ONLY public.master_fakultas
    ADD CONSTRAINT master_fakultas_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.master_prodi
    ADD CONSTRAINT master_prodi_kode_key UNIQUE (kode);
ALTER TABLE ONLY public.master_prodi
    ADD CONSTRAINT master_prodi_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.master_universitas
    ADD CONSTRAINT master_universitas_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.navigation
    ADD CONSTRAINT navigation_parent_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_name_key UNIQUE (name);
ALTER TABLE ONLY public.role_navigation
    ADD CONSTRAINT role_navigation_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.setting_pembayaran
    ADD CONSTRAINT setting_pembayaran_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.tahun_ajar
    ADD CONSTRAINT tahun_ajar_name_key UNIQUE (name);
ALTER TABLE ONLY public.tahun_ajar
    ADD CONSTRAINT tahun_ajar_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_karyawan
    ADD CONSTRAINT user_karyawan_email_key UNIQUE (email);
ALTER TABLE ONLY public.user_karyawan
    ADD CONSTRAINT user_karyawan_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.user_karyawan_role
    ADD CONSTRAINT user_karyawan_role_pkey PRIMARY KEY (id);
CREATE TRIGGER set_public_keuangan_pembayaran_mahasiswa_kwitansi_updated_at BEFORE UPDATE ON public.keuangan_pembayaran_mahasiswa_kwitansi FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_keuangan_pembayaran_mahasiswa_kwitansi_updated_at ON public.keuangan_pembayaran_mahasiswa_kwitansi IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_keuangan_pembayaran_mahasiswa_rincian_updated_at BEFORE UPDATE ON public.keuangan_pembayaran_mahasiswa_rincian FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_keuangan_pembayaran_mahasiswa_rincian_updated_at ON public.keuangan_pembayaran_mahasiswa_rincian IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_keuangan_pembayaran_mahasiswa_updated_at BEFORE UPDATE ON public.keuangan_pembayaran_mahasiswa FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_keuangan_pembayaran_mahasiswa_updated_at ON public.keuangan_pembayaran_mahasiswa IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_keuangan_tipe_pembayaran_updated_at BEFORE UPDATE ON public.keuangan_tipe_pembayaran FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_keuangan_tipe_pembayaran_updated_at ON public.keuangan_tipe_pembayaran IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_master_fakultas_updated_at BEFORE UPDATE ON public.master_fakultas FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_master_fakultas_updated_at ON public.master_fakultas IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_master_universitas_updated_at BEFORE UPDATE ON public.master_universitas FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_master_universitas_updated_at ON public.master_universitas IS 'trigger to set value of column "updated_at" to current timestamp on row update';
CREATE TRIGGER set_public_user_karyawan_updated_at BEFORE UPDATE ON public.user_karyawan FOR EACH ROW EXECUTE FUNCTION public.set_current_timestamp_updated_at();
COMMENT ON TRIGGER set_public_user_karyawan_updated_at ON public.user_karyawan IS 'trigger to set value of column "updated_at" to current timestamp on row update';
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_id_mahasiswa_fkey FOREIGN KEY (id_mahasiswa) REFERENCES public.mahasiswa(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_kwitansi
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_id_pembayaran_mahasiswa_rinc_fkey FOREIGN KEY (id_pembayaran_mahasiswa_rincian) REFERENCES public.keuangan_pembayaran_mahasiswa_rincian(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_kwitansi
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_kwitansi_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.user_karyawan(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_kwitansi
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_kwitansi_id_tipe_pembayaran_fk FOREIGN KEY (id_jenis_pembayaran) REFERENCES public.keuangan_jenis_pembayaran(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_rincian
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_rinc_id_pembayaran_mahasiswa_fkey FOREIGN KEY (id_pembayaran_mahasiswa) REFERENCES public.keuangan_pembayaran_mahasiswa(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.keuangan_pembayaran_mahasiswa_rincian
    ADD CONSTRAINT keuangan_pembayaran_mahasiswa_rincian_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.user_karyawan(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.mahasiswa_pakai_sistem
    ADD CONSTRAINT mahasiswa_pakai_sistem_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.user_karyawan(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.mahasiswa_pakai_sistem
    ADD CONSTRAINT mahasiswa_pakai_sistem_id_mahasiswa_fkey FOREIGN KEY (id_mahasiswa) REFERENCES public.mahasiswa(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.master_prodi
    ADD CONSTRAINT master_prodi_id_fakultas_fkey FOREIGN KEY (id_fakultas) REFERENCES public.master_fakultas(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.master_universitas
    ADD CONSTRAINT master_universitas_last_updated_by_fkey FOREIGN KEY (last_updated_by) REFERENCES public.user_karyawan(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.role_navigation
    ADD CONSTRAINT role_navigation_id_navigation_fkey FOREIGN KEY (id_navigation) REFERENCES public.navigation(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.role_navigation
    ADD CONSTRAINT role_navigation_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.role(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_karyawan_role
    ADD CONSTRAINT user_karyawan_role_id_role_fkey FOREIGN KEY (id_role) REFERENCES public.role(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
ALTER TABLE ONLY public.user_karyawan_role
    ADD CONSTRAINT user_karyawan_role_id_user_karyawan_fkey FOREIGN KEY (id_user_karyawan) REFERENCES public.user_karyawan(id) ON UPDATE RESTRICT ON DELETE RESTRICT;
