WARNING:  database "postgres" has a collation version mismatch
DETAIL:  The database was created using collation version 2.36, but the operating system provides version 2.41.
HINT:  Rebuild all objects in this database that use the default collation and run ALTER DATABASE postgres REFRESH COLLATION VERSION, or build PostgreSQL with the right library version.
--
-- PostgreSQL database dump
--

\restrict K7KJ47UaRlfJ0aUJPMDZ4FNYWGAyzrLvfmyJcIPnD5mX37b3d4juABhRmgdhISD

-- Dumped from database version 17.6 (Debian 17.6-1.pgdg13+1)
-- Dumped by pg_dump version 17.6 (Debian 17.6-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: fms_ip; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fms_ip (
    id integer NOT NULL,
    mac macaddr,
    ip inet,
    public_ip inet,
    unit_full_name text,
    hdh text,
    nv text
);


ALTER TABLE public.fms_ip OWNER TO postgres;

--
-- Name: fms_ip_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fms_ip_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fms_ip_id_seq OWNER TO postgres;

--
-- Name: fms_ip_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fms_ip_id_seq OWNED BY public.fms_ip.id;


--
-- Name: ip_ranges; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ip_ranges (
    id integer NOT NULL,
    parent_unit_name character varying(255),
    unit_name character varying(255),
    ip_range cidr,
    last_scanned_at timestamp with time zone
);


ALTER TABLE public.ip_ranges OWNER TO postgres;

--
-- Name: ip_ranges_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ip_ranges_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ip_ranges_id_seq OWNER TO postgres;

--
-- Name: ip_ranges_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ip_ranges_id_seq OWNED BY public.ip_ranges.id;


--
-- Name: scan_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_profile (
    id bigint NOT NULL,
    name text NOT NULL,
    description text,
    bot_kind text,
    args text NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.scan_profile OWNER TO postgres;

--
-- Name: scan_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.scan_profile ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.scan_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: scan_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.scan_results (
    id integer NOT NULL,
    ip_range_id integer,
    ip inet,
    port integer,
    status_port character varying(20),
    first_detect timestamp without time zone,
    last_scan timestamp without time zone,
    os json,
    detail_port json
);


ALTER TABLE public.scan_results OWNER TO postgres;

--
-- Name: scan_results_update_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.scan_results_update_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.scan_results_update_id_seq OWNER TO postgres;

--
-- Name: scan_results_update_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.scan_results_update_id_seq OWNED BY public.scan_results.id;


--
-- Name: fms_ip id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fms_ip ALTER COLUMN id SET DEFAULT nextval('public.fms_ip_id_seq'::regclass);


--
-- Name: ip_ranges id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ip_ranges ALTER COLUMN id SET DEFAULT nextval('public.ip_ranges_id_seq'::regclass);


--
-- Name: scan_results id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_results ALTER COLUMN id SET DEFAULT nextval('public.scan_results_update_id_seq'::regclass);


--
-- Data for Name: fms_ip; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fms_ip (id, mac, ip, public_ip, unit_full_name, hdh, nv) FROM stdin;
1	70:85:c2:69:f3:fe	86.38.128.50	86.38.128.50	Phòng Chính trị-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	Ban Tổ chức phòng chính trị
2	00:30:67:d8:e0:af	86.38.128.178	86.38.128.178	Phòng Chính trị-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phòng Chính trị Học viện PK
3	04:42:1a:95:93:c5	86.38.124.79	86.38.124.79	Khoa Khoa Học Cơ Bản-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng khoa Khoa học cơ bản
4	00:30:67:0f:d3:71	86.38.124.114	86.38.124.114	Khoa Chỉ Huy Hậu Cần-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ Môn Xe Máy Khoa Ghỉ huy Hậu cần
5	94:de:80:c4:87:3e	86.38.128.107	86.38.128.107	Hệ 2-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Chính trị viên Hệ 2
6	04:42:1a:95:94:ad	86.38.128.59	86.38.128.59	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	NVTK Ban Tổ chức
7	00:30:67:d8:e7:9e	86.38.128.88	86.38.128.88	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Ban Không quân HC-KT
8	ec:8e:b5:d6:b8:7b	86.38.124.111	86.38.124.111	Khoa Chỉ Huy Hậu Cần-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng khoa Chỉ huy Hậu cần
9	08:2e:5f:0b:c3:f4	86.38.128.79	86.38.128.79	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trợ lý CNTT
10	a0:36:bc:0b:bf:e7	86.38.128.169	86.38.128.169	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trưởng ban Quản lý P.KHQS
11	ec:8e:b5:d6:b8:90	86.38.124.64	86.38.124.64	Khoa Công Tác Đảng CTCT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó TK1 Khoa Công tác Đảng
12	6c:f0:49:83:f6:4d	86.38.128.175	86.38.128.175	Phòng Chính trị-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phòng Chính trị Học viện PKKQ
13	00:25:22:b5:9d:4d	86.38.128.149	86.38.128.149	Tiểu Đoàn 7-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	chính trị viên tiểu đoàn 7
14	70:85:c2:04:6d:3e	86.38.124.57	86.38.124.57	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn Binh khí PPK
15	54:bf:64:9c:73:4d	86.38.128.42	86.38.128.42	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	Ban CB Phòng chính trị
16	00:24:21:ab:4f:4f	86.38.128.121	86.38.128.121	Hệ 3-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Chính trị viên Hệ 3
17	00:1f:d0:c3:df:57	86.38.128.155	86.38.128.155	Trung Tâm Huấn Luyện Thực Hành-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trưởng trung tâm HLTH
18	8c:ec:4b:b7:6c:18	86.38.128.196	86.38.128.196	Trung Tâm Mô Phỏng-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng Trung tâm Mô phỏng Học viện PKKQ
19	8c:ec:4b:b7:76:eb	86.38.128.197	86.38.128.197	Trung Tâm Mô Phỏng-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó Trung tâm Mô Phỏng Học viện PKKQ
20	7c:10:c9:d0:bd:99	86.38.124.56	86.38.124.56	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Phó TK2 Khoa pháo PK
21	58:8a:5a:22:90:64	86.38.128.135	86.38.128.135	Tiểu Đoàn 5-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Chính trị viên tiểu đoàn 5
22	6c:f0:49:85:05:cf	86.38.124.29	86.38.124.29	Khoa Tên Lửa-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn CT phân đội Tên lửa
23	ec:b1:d7:31:64:98	86.38.128.163	86.38.128.163	Hệ 10-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Chính trị viên H10
24	ec:8e:b5:d6:b8:9a	86.38.124.98	86.38.124.98	Khoa Quân Sự Chung-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó CN1 Khoa Quân sự chung
25	ec:8e:b5:d6:b8:c2	86.38.128.52	86.38.128.52	Phòng Đào tạo-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó TP1 đào tạo
26	00:e0:4c:12:94:6d	86.38.128.87	86.38.128.87	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trợ lý KH Phòng Hậu cần
27	d4:85:64:02:00:77	86.38.124.55	86.38.124.55	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phó trưởng khoa Pháo PK
28	00:1f:e2:3f:ee:f6	86.38.128.120	86.38.128.120	Tiểu Đoàn 8-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Tiểu đoàn trưởng tiểu đoàn 8
29	c0:25:a5:a6:10:b1	86.38.128.36	86.38.128.36	Phòng TM-HC-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Văn thư Phòng TMHC
30	7c:10:c9:d1:e0:10	86.38.124.12	86.38.124.12	Khoa Chiến Thuật Chiến Dịch-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Khoa Chiến thuật chiến Dịch
31	18:a9:05:25:f3:e7	86.38.128.56	86.38.128.56	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trưởng ban KHCT_PĐT
32	04:42:1a:95:9b:10	86.38.124.105	86.38.124.105	Khoa Chỉ Huy Tham Mưu-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó CN1 Khoa Chỉ huy tham mưu
33	18:c0:4d:5d:76:ea	86.38.128.127	86.38.128.127	Tiểu Đoàn 4-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Tiểu đoàn trưởng tiểu đoàn 4
34	6c:f0:49:85:08:6b	86.38.124.135	86.38.124.135	Khoa Tên Lửa-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Khoa Tên Lửa
35	b4:2e:99:d8:a8:2f	86.38.128.86	86.38.128.86	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trợ lý CT Hậu cần- Kỹ thuật
36	60:02:92:38:49:32	86.38.124.59	86.38.124.59	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Khoa Pháo Phòng Không
37	e0:73:e7:cf:3d:73	86.38.128.177	86.38.128.177	Phòng Chính trị-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phòng Chính trị Học Viện PKKQ
38	74:d4:35:03:7b:ec	86.38.124.35	86.38.124.35	Khoa RADA-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phó TK1 Rada 
39	e8:03:9a:64:ed:93	86.38.128.47	86.38.128.47	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Ủy banKT Phòng chính trị
40	e0:73:e7:cf:3e:45	86.38.128.175	86.38.128.175	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Ban TC Phòng chính trị
41	00:30:67:f0:3b:3b	86.38.128.171	86.38.128.171	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Ban Quản lý Học viện PKKQ
42	8c:ec:4b:b7:6e:7f	86.38.128.198	86.38.128.198	Trung Tâm Mô Phỏng-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trợ lý KH TTMP Học viện PKKQ
43	1c:6f:65:48:0e:9d	86.38.128.100	86.38.128.100	Hệ 1-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Chính trị viên H1
44	04:42:1a:95:9c:50	86.38.124.54	86.38.124.54	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	trưởng khoa Pháo PK
45	08:2e:5f:0b:cc:40	86.38.128.181	86.38.128.181	Khoa Thông Tin Tác Chiến Điện Tử-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phó TK thông tin TC_ĐT
46	00:24:21:e5:c7:96	86.38.128.55	86.38.128.55	Phòng Đào tạo-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trợ lý CT P.Đào tạo
47	54:bf:64:9c:67:9e	86.38.124.185	86.38.124.185	Khoa Thông Tin Tác Chiến Điện Tử-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Khoa TCĐT
48	00:30:67:d8:e8:86	86.38.128.27	86.38.128.27	Phòng TM-HC-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phó TP TMHC
49	dc:4a:3e:66:01:5a	86.38.128.176	86.38.128.176	Phòng Chính trị-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phòng Chính trị HV PKKQ
50	00:30:67:d8:ea:ec	86.38.124.28	86.38.124.28	Khoa Tên Lửa-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn Xạ kích Khoa tên lửa
51	ec:8e:b5:d6:b8:b3	86.38.124.44	86.38.124.44	Khoa Dẫn Đường Khí Tượng-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10586, 64-bit Edition)	Phó TK1 khoa Dẫn đường
52	7c:10:c9:d2:ad:4d	86.38.124.97	86.38.124.97	Khoa Quân Sự Chung-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trưởng khoa Quân sự chung
53	8c:ec:4b:b3:c7:20	86.38.128.199	86.38.128.199	Trung Tâm Mô Phỏng-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trung tâm mô phỏng Học viện PKKQ
54	04:42:1a:95:94:c3	86.38.124.112	86.38.124.112	Khoa Chỉ Huy Hậu Cần-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Phó CN1 Khoa Chỉ huy Hậu cần
55	6c:f0:49:85:54:f1	86.38.124.67	86.38.124.67	Khoa Công Tác Đảng CTCT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn CTĐảng khoa Công tác Đảng
56	58:11:22:49:54:79	86.38.128.128	86.38.128.128	Tiểu Đoàn 4-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	chính trị viên tiểu đoàn 4
57	8c:ec:4b:b7:6b:c7	86.38.124.95	86.38.124.95	Khoa Lý Luận Mác LN-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Bộ môn Tư tưởng HCM Khoa LL MLN
58	00:1f:d0:12:d7:5b	86.38.124.31	86.38.124.31	Khoa Tên Lửa-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn bệ đạn khoa Tên lửa
59	34:64:a9:34:62:ff	86.38.128.54	86.38.128.54	Phòng Đào tạo-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trợ lý KH P.Đào tạo
60	e8:03:9a:66:09:5c	86.38.124.58	86.38.124.58	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Bộ môn Khí tài Khoa PháoPK
61	90:fb:a6:ea:f3:ff	86.38.128.77	86.38.128.77	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trợ lý CT P. KHQS
62	7c:10:c9:d1:e0:1f	86.38.124.60	86.38.124.60	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Bộ môn tên lửa tầm thấp Khoa Pháo
63	ec:8e:b5:d6:b8:84	86.38.124.118	86.38.124.118	Khoa Kỹ Thuật Hàng Không-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng khoa Kỹ Thuật Hàng không
64	04:42:1a:96:7d:3c	86.38.124.27	86.38.124.27	Khoa Tên Lửa-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó TK tên lửa
65	04:42:1a:95:98:4d	86.38.124.43	86.38.124.43	Khoa Dẫn Đường Khí Tượng-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trưởng khoa Dẫn đường
66	04:42:1a:95:9a:57	86.38.128.31	86.38.128.31	Phòng TM-HC-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	TB Quân lực
67	7c:10:c9:d1:e0:a2	86.38.124.93	86.38.124.93	Khoa Lý Luận Mác LN-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Bộ môn KT chính trị Khoa LL Mac LN
68	7c:10:c9:d1:e2:d5	86.38.124.62	86.38.124.62	Khoa Công Tác Đảng CTCT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trưởng khoa Công tác Đảng
69	fc:34:97:e6:5f:d6	86.38.124.200	86.38.124.200	Khoa Kỹ Thuật Cơ Sở-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng khoa Kỹ thuật cơ sở
70	e0:69:95:ee:bb:7f	86.38.128.252	86.38.128.252	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phòng Hậu Cần KT Học viện PKKQ
71	e0:69:95:f2:2a:bb	86.38.128.79	86.38.128.79	Ban Giám Đốc-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Giám đốc
72	8c:ec:4b:b7:6b:7a	86.38.128.44	86.38.128.44	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Ban TH Phòng chính trị
73	04:42:1a:95:97:32	86.38.128.15	86.38.128.15	Ban Giám Đốc-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	PGĐ Kỹ thuật
74	04:42:1a:95:91:14	86.38.124.119	86.38.124.119	Khoa Kỹ Thuật Hàng Không-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Phó CN1 Khoa Hỹ thuật Hàng Không
75	e0:d5:5e:40:dc:3f	86.38.128.53	86.38.128.53	Phòng Đào tạo-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng phòng Đào tạo
76	e0:69:95:ea:b3:4a	86.38.128.25	86.38.128.25	Phòng TM-HC-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trưởng phòng TMHC
77	ec:8e:b5:66:a3:52	86.38.124.26	86.38.124.26	Khoa Tên Lửa-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10586, 64-bit Edition)	Trưởng khoa tên lửa
78	e0:69:95:ea:b4:fd	86.38.128.83	86.38.128.83	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	P. Trưởng phòng HC-KT
79	e8:11:32:38:bc:d5	86.38.128.61	86.38.128.61	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trưởng phòng Hậu cần
80	8c:ec:4b:b7:6b:56	86.38.124.90	86.38.124.90	Khoa Lý Luận Mác LN-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó TK1 Lý luận MAC LN
81	d4:85:64:02:00:09	86.38.124.91	86.38.124.91	Khoa Lý Luận Mác LN-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phó TK2 Lý luận Mac LN
82	8c:ec:4b:d4:d2:f9	86.38.128.57	86.38.128.57	Phòng Đào tạo-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng ban sau đại học P.ĐT
83	4c:ed:fb:78:ce:cc	86.70.30.152	86.70.30.152	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Phan Đình Sáng
84	3c:7c:3f:d6:a3:8e	86.70.30.241	86.70.30.241	Tiểu đoàn 3-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Mai Tiến Hoạt
85	00:0c:29:05:c1:a2	86.70.30.243	86.70.30.243	Trường SQKQ-Quan chung PKKQ		Admin
86	18:c0:4d:5b:1f:3b	86.70.30.96	86.70.30.96	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
87	00:30:67:38:3b:70	86.70.30.228	86.70.30.228	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Lê Văn Hà
88	d8:bb:c1:e0:9b:0e	86.70.30.210	86.70.30.210	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
89	18:c0:4d:5a:cc:85	86.70.30.236	86.70.30.236	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Lại Hồng Sơn
90	f0:2f:74:b2:e0:54	86.70.31.241	86.70.31.241	Khoa Vô tuyến điện tử-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Tạ Văn Nhâm
91	38:2c:4a:70:c6:e8	86.70.30.161	86.70.30.161	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Hữu Hiếu
92	00:15:5d:1e:14:08	86.70.30.2	86.70.30.2	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 14393, 64-bit Edition)	Phan Đình Sáng
93	14:dd:a9:e6:6b:4d	86.70.30.169	86.70.30.169	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phùng Văn Sơn
94	3c:7c:3f:d6:a1:cf	86.70.30.242	86.70.30.242	Tiểu đoàn 3-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Nguyễn Tiến Dũng
95	d8:5e:d3:f9:fa:4e	86.70.30.117	86.70.30.117	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
96	90:1b:0e:98:78:de	86.70.30.9	86.70.30.9	Trường SQKQ-Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 14393, 64-bit Edition)	Admin
97	24:be:05:21:de:4f	86.70.30.221	86.70.30.221	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
98	c8:7f:54:57:a3:8f	86.70.30.109	86.70.30.109	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
99	14:02:ec:06:9f:7c	86.70.30.6	86.70.30.6	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 17763, 64-bit Edition)	Nguyễn Thế Anh
100	e4:54:e8:db:66:c8	86.70.30.245	86.70.30.245	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
101	c8:7f:54:57:a3:15	86.70.30.144	86.70.30.144	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
102	c8:7f:54:50:a7:e1	86.70.30.92	86.70.30.92	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
103	00:e0:4c:36:06:1c	86.70.30.153	86.70.30.153	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
104	04:42:1a:ac:e9:92	86.70.30.130	86.70.30.130	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
105	98:40:bb:3a:65:e8	86.70.30.126	86.70.30.126	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Nguyễn Minh Sang
106	04:92:26:d6:ca:d9	86.70.30.168	86.70.30.168	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Phan Đình Sáng
107	70:85:c2:f7:37:a6	86.70.30.141	86.70.30.141	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
108	4c:52:62:23:b4:27	86.70.30.61	86.70.30.61	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17133, 32-bit Edition)	Giang Trung Hiếu
109	d8:bb:c1:a7:5f:2f	86.70.30.133	86.70.30.133	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Nguyễn Thành Trung
110	d8:bb:c1:a7:60:46	86.70.30.99	86.70.30.99	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
111	3c:7c:3f:d6:a3:3f	86.70.30.98	86.70.30.98	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
112	4c:cc:6a:68:b9:4a	86.70.31.250	86.70.31.250	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
113	00:e0:4c:78:66:53	86.70.30.226	86.70.30.226	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Thị Hoàn
114	70:8b:cd:55:a8:de	86.70.30.227	86.70.30.227	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 15063, 64-bit Edition)	Hoàng Minh Phúc
115	c8:7f:54:57:a4:1c	86.70.31.59	86.70.31.59	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
116	18:c0:4d:d6:3f:e3	86.70.30.153	86.70.30.153	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Huỳnh Tấn Diện
117	04:42:1a:ac:e9:a0	86.70.30.127	86.70.30.127	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
118	00:d8:61:6d:68:05	86.70.30.15	86.70.30.15	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Nguyễn Quang Tuấn
119	00:24:21:5c:b1:64	86.70.30.178	86.70.30.178	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Văn Thanh
120	a8:a1:59:9c:7e:22	86.70.30.120	86.70.30.120	Tiểu đoàn 2-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Đỗ Trọng Sáng
121	74:56:3c:7b:b8:43	86.70.30.193	86.70.30.193	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
122	90:fb:a6:65:1c:94	86.70.30.164	86.70.30.164	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Đức Quyền
123	80:e8:2c:b8:bf:30	86.70.30.129	86.70.30.129	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
124	70:85:c2:ce:2d:50	86.70.30.108	86.70.30.108	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	Nguyễn Thành Vinh
125	c8:7f:54:57:a5:a7	86.70.30.150	86.70.30.150	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
126	e0:d5:5e:78:99:82	86.70.30.64	86.70.30.64	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	Bùi Như Khuê
127	a8:a1:59:8d:a1:65	86.70.30.190	86.70.30.190	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Admin
128	78:24:af:8e:2a:c9	86.70.31.245	86.70.31.245	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Đỗ Văn Nam
129	a8:a1:59:8b:69:ad	86.70.30.174	86.70.30.174	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Lưu Thế Mạnh
130	14:da:e9:9f:2c:eb	86.70.30.163	86.70.30.163	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Admin
131	04:42:1a:95:99:88	86.38.124.89	86.38.124.89	Khoa Lý Luận Mác LN-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trưởng khoa Lý luận MácLN
132	fc:aa:14:dd:2c:ca	86.70.30.192	86.70.30.192	Phòng Hậu cần-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trần Hoài Nam
133	c8:7f:54:57:a5:45	86.70.30.170	86.70.30.170	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
134	a0:36:bc:0c:1f:8f	86.70.30.131	86.70.30.131	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
135	fc:34:97:e6:53:92	86.38.128.14	86.38.128.14	Ban Giám Đốc-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó Chính ủy
136	74:85:2a:1d:6a:c6	86.70.30.240	86.70.30.240	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Hà Văn Huần
137	d8:cb:8a:73:69:89	86.70.30.45	86.70.30.45	Phòng Hậu cần-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Hoàng Ngọc Tâm
138	ec:8e:b5:d6:b8:ca	86.38.124.24	86.38.124.24	Khoa Chiến Thuật Chiến Dịch-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Khoa CT-CD Học viện PKKQ
139	8c:89:a5:42:15:90	86.70.28.60	86.70.28.60	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Tống Quang Duy
140	6c:f0:49:41:88:f1	86.70.30.224	86.70.30.224	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trần Văn Đạo
141	ec:8e:b5:66:9c:d2	86.38.124.116	86.38.124.116	Khoa Chỉ Huy Hậu Cần-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Bộ Môn Nghiệp vụ HC Khoa Chỉ huy Hậu cần
142	d8:5e:d3:f9:22:d3	86.70.30.249	86.70.30.249	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
143	4c:52:62:23:b1:e7	86.70.30.62	86.70.30.62	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Đỗ Trung Bộ
144	d8:5e:d3:f8:11:5f	86.70.30.107	86.70.30.107	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
145	00:1a:a0:96:80:d2	86.70.30.223	86.70.30.223	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Hải Đăng
146	70:85:c2:c0:0e:4a	86.70.31.244	86.70.31.244	Khoa Vô tuyến điện tử-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Khuất Văn Huy
147	4c:ed:fb:78:c9:06	86.70.30.186	86.70.30.186	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
148	d8:5e:d3:f8:22:9e	86.70.30.58	86.70.30.58	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
149	44:8a:5b:9b:90:91	86.70.30.171	86.70.30.171	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Vũ Văn Hoạt
150	f0:2f:74:b2:e1:f8	86.70.30.149	86.70.30.149	Khoa Khoa học xã hội & Nhân văn-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Cao Văn Khoa
151	70:85:c2:f7:33:0f	86.70.31.242	86.70.31.242	Khoa Vô tuyến điện tử-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Lưu Viết Tuần
152	18:c0:4d:e8:dd:51	86.70.30.199	86.70.30.199	Khoa Khoa học xã hội & Nhân văn-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trần Thanh Bình
153	00:e0:4c:82:06:56	86.70.30.218	86.70.30.218	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Thành Trung
154	30:9c:23:29:d2:99	86.70.30.105	86.70.30.105	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phạm Thị Mai Hoa
155	70:85:c2:b5:16:81	86.70.30.145	86.70.30.145	Khoa Khoa học xã hội & Nhân văn-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Lê Đức Tuyên
156	18:c0:4d:5c:9e:03	86.70.30.116	86.70.30.116	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Nguyễn Thành Dân
157	40:16:7e:73:9c:37	86.70.30.214	86.70.30.214	Phòng Kỹ thuật-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Hoàng Anh Tuấn
158	b8:2a:72:9d:f7:1b	86.70.31.248	86.70.31.248	Khoa Vô tuyến điện tử-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Hoàng Việt Hòa
159	04:42:1a:ac:e0:12	86.70.30.148	86.70.30.148	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
160	4c:cc:6a:4f:71:3f	86.70.30.152	86.70.30.152	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
161	58:11:22:06:22:16	86.70.30.88	86.70.30.88	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
162	00:30:67:39:c8:b5	86.70.30.222	86.70.30.222	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Vũ Thanh Bình
163	04:42:1a:96:80:08	86.38.124.80	86.38.124.80	Khoa Khoa Học Cơ Bản-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Phó TK1 Khoa Khoa Học cơ bản
164	4c:ed:fb:78:c8:9b	86.70.30.68	86.70.30.68	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
694	30:0e:d5:d0:a3:ab	192.168.104.52	192.168.104.52	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
165	dc:fe:07:d3:0b:3d	86.70.28.55	86.70.28.55	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
166	e4:54:e8:cd:af:11	86.70.30.233	86.70.30.233	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	Nguyễn Văn Vương
167	00:30:67:d8:d9:e2	86.38.128.253	86.38.128.253	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trưởng TTCNTT
168	00:30:67:0f:d5:20	86.38.128.32	86.38.128.32	Phòng TM-HC-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Ban TT P.TMHC
169	50:e5:49:8a:1c:6e	86.70.30.143	86.70.30.143	Phòng Quân huấn-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phạm Thị Hoàn
170	f0:79:59:8e:02:cb	86.70.30.229	86.70.30.229	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
171	c8:7f:54:57:a2:47	86.70.30.147	86.70.30.147	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
172	2c:fd:a1:5a:fd:4d	86.70.30.119	86.70.30.119	Tiểu đoàn 2-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	Đỗ Trọng Sáng
173	e0:d5:5e:78:9d:4c	86.70.30.97	86.70.30.97	Trung tâm Huấn luyện Thực hành-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Nguyễn Văn Quang
174	4c:52:62:26:c8:71	86.70.30.90	86.70.30.90	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
175	d8:bb:c1:a7:5f:32	86.70.30.132	86.70.30.132	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Phan Đình Sáng
176	30:85:a9:f7:4e:d9	86.70.30.198	86.70.30.198	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phùng Văn Sơn
177	fc:aa:14:ac:7d:75	86.70.30.121	86.70.30.121	Phòng Quân huấn-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Đào Thiện Hùng
178	18:31:bf:6e:60:85	86.70.30.102	86.70.30.102	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Đỗ Quang Huy
179	00:0c:04:0f:21:27	86.70.30.128	86.70.30.128	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
180	fc:34:97:e6:6d:3d	86.38.124.11	86.38.124.11	Khoa Chiến Thuật Chiến Dịch-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Bôn môn CT rada khoa CTCD
181	b8:2a:72:b9:eb:7a	86.70.30.115	86.70.30.115	Phòng Quân huấn-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Văn Thanh
182	70:85:c2:b5:17:23	86.70.31.245	86.70.31.245	Ban Giám hiệu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10586, 64-bit Edition)	Ngô Vĩnh Phúc
183	74:d4:35:cd:19:bc	86.70.30.217	86.70.30.217	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
184	4c:ed:fb:78:c9:a8	86.70.30.87	86.70.30.87	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Vũ Thị Hoa
185	50:eb:f6:1d:be:9d	86.70.31.80	86.70.31.80	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
186	34:97:f6:90:df:6b	86.70.30.78	86.70.30.78	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	Vũ Mạnh Tuấn
187	c8:7f:54:57:a2:20	86.70.30.123	86.70.30.123	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
188	fc:34:97:e6:52:d8	86.38.124.34	86.38.124.34	Khoa RADA-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trưởng khoa Rada
189	1c:1b:0d:b6:44:f1	86.38.124.13	86.38.124.13	Khoa Chiến Thuật Chiến Dịch-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Khoa CT-CD học viện PKKQ
190	54:bf:64:9c:5c:f4	86.38.124.83	86.38.124.83	Khoa Khoa Học Cơ Bản-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Bộ môn Tin Khoa cơ bản
191	00:01:09:09:1e:0b	86.70.30.28	86.70.30.28	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
192	00:24:1d:34:16:e2	86.38.124.66	86.38.124.66	Khoa Công Tác Đảng CTCT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn tâm lý Khoa CTĐảng
193	08:94:ef:3a:54:32	86.70.30.11	86.70.30.11	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 14393, 64-bit Edition)	Phan Đình Sáng
194	4c:ed:fb:78:c8:7d	86.70.30.65	86.70.30.65	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
195	3c:7c:3f:d6:a1:48	86.70.30.122	86.70.30.122	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
196	3c:7c:3f:d6:a4:9c	86.70.30.66	86.70.30.66	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
197	00:25:11:29:b4:63	86.38.124.68	86.38.124.68	Khoa Công Tác Đảng CTCT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn nhà nước PL Khoa CTĐảng
198	00:30:67:0f:d3:2b	86.38.124.104	86.38.124.104	Khoa Chỉ Huy Tham Mưu-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trưởng khoa Chỉ huy TM
199	00:e0:4c:80:b3:64	86.70.30.225	86.70.30.225	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Chu Ngọc Tuấn
200	b0:83:fe:92:3c:8f	86.70.30.211	86.70.30.211	Phòng Khoa học quân sự-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Nguyễn Hoàng Nam
201	c8:60:00:bd:20:7a	86.70.30.112	86.70.30.112	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phạm Quang Tùng
202	60:02:92:1e:90:d7	86.38.124.122	86.38.124.122	Khoa Kỹ Thuật Hàng Không-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn VK-HK Khoa kỹ thuật hàng không
203	98:e7:43:0a:ab:e1	86.70.31.249	86.70.31.249	Trung tâm Huấn luyện Thực hành-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Chu Tuấn Anh
204	4c:ed:fb:78:cb:92	86.70.30.93	86.70.30.93	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
205	7c:57:58:3a:31:05	86.70.30.141	86.70.30.141	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
206	e0:d5:5e:81:6f:9e	86.70.30.177	86.70.30.177	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Admin
207	00:e0:4c:b6:7e:60	86.70.31.246	86.70.31.246	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
208	00:0f:fe:c9:e2:85	86.38.128.232	86.38.128.232	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trợ lý CNTT
209	8c:ec:4b:b7:6d:62	86.38.124.88	86.38.124.88	Khoa Ngoại Ngữ Ngữ Văn-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Bộ môn tiếng Anh Học viện PKKQ
210	08:2e:5f:0b:cc:63	86.38.128.129	86.38.128.129	Khoa Thông Tin Tác Chiến Điện Tử-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn CTCĐ khoa TC_ĐT
211	d0:50:99:91:13:42	86.70.30.125	86.70.30.125	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
212	c8:60:00:b3:0d:ec	86.70.30.185	86.70.30.185	Phòng Hậu cần-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Trần Hoài Nam
213	40:a8:f0:4b:db:b4	192.168.6.16	192.168.6.16	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
214	74:d4:35:c3:4f:48	86.70.30.197	86.70.30.197	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
215	40:a8:f0:49:e0:ec	192.168.34.17	192.168.34.17	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
216	a8:a1:59:30:6e:20	192.168.51.31	192.168.51.31	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
217	00:e0:4c:68:12:be	192.168.144.30	192.168.144.30	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
218	00:e0:4c:68:12:36	192.168.5.106	192.168.5.106	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
219	24:0b:2a:f1:c4:8d	192.168.104.29	192.168.104.29	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
220	98:ee:cb:e5:c2:a4	192.168.6.115	192.168.6.115	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
221	40:a8:f0:4b:db:b0	192.168.162.56	192.168.162.56	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
222	c0:25:a5:c7:04:a9	192.168.123.16	192.168.123.16	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
223	24:0b:2a:f1:c2:71	192.168.162.39	192.168.162.39	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
224	8c:ec:4b:73:f3:a4	192.168.123.20	192.168.123.20	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Admin
225	24:0b:2a:f1:c0:d9	192.168.162.27	192.168.162.27	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
226	e0:73:e7:bd:13:59	192.168.79.51	192.168.79.51	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	Admin
227	24:0b:2a:f1:c7:58	192.168.6.251	192.168.6.251	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
228	30:0e:d5:d0:11:6e	192.168.36.110	192.168.36.110	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
229	d8:5e:d3:66:f2:3b	192.168.36.179	192.168.36.179	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
230	74:d4:35:a6:6f:9b	192.168.6.17	192.168.6.17	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
231	b0:83:fe:90:de:bf	192.168.36.10	192.168.36.10	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
232	48:0f:cf:bc:b7:89	192.168.36.142	192.168.36.142	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
233	20:cf:30:ac:79:55	192.168.81.11	192.168.81.11	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	Admin
234	c8:d9:d2:22:a6:77	192.168.6.114	192.168.6.114	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
235	78:45:c4:3f:b0:29	192.168.162.47	192.168.162.47	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
236	24:0b:2a:f1:c7:ba	192.168.162.20	192.168.162.20	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
237	6c:4b:90:01:2e:e2	192.168.41.105	192.168.41.105	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
238	74:27:ea:ff:0a:52	192.168.41.1	192.168.41.1	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
239	00:19:d1:7b:b0:55	192.168.52.28	192.168.52.28	Phòng Hành chính hậu cần-Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Lê Mạnh Hùng
240	dc:4a:3e:96:45:a8	192.168.201.12	192.168.201.12	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
241	dc:4a:3e:96:62:b7	86.48.64.145	86.48.64.145	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Máy dùng chung
242	4c:52:62:31:4d:66	192.168.11.113	192.168.11.113	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
243	d0:27:88:ba:68:da	192.168.11.107	192.168.11.107	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
244	74:27:ea:ff:0a:69	192.168.41.101	192.168.41.101	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
245	18:c0:4d:65:12:9d	192.168.36.131	192.168.36.131	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
246	c8:f7:50:ff:21:32	192.168.41.10	192.168.41.10	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
247	24:0b:2a:f1:bc:95	192.168.162.36	192.168.162.36	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
248	40:8d:5c:05:f1:73	192.168.36.117	192.168.36.117	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
249	18:c0:4d:1f:57:6b	192.168.6.106	192.168.6.106	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Trạm BĐKT
250	50:9a:4c:31:24:ad	192.168.123.18	192.168.123.18	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	Admin
251	90:fb:a6:29:19:39	192.168.36.129	192.168.36.129	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
252	d8:5e:d3:f9:f1:42	192.168.36.138	192.168.36.138	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
253	10:60:4b:69:16:83	192.168.52.37	192.168.52.37	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
254	18:60:24:b6:58:08	192.168.52.43	192.168.52.43	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
255	6c:f0:49:16:fc:2b	192.168.201.58	192.168.201.58	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
256	40:a8:f0:49:e0:2a	192.168.36.12	192.168.36.12	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10586, 64-bit Edition)	Admin
257	dc:4a:3e:94:f8:4c	86.48.64.145	86.48.64.145	Lữ đoàn 918-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phòng Tham mưu
258	6c:4b:90:01:30:28	192.168.41.103	192.168.41.103	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
259	70:85:c2:b5:18:89	86.70.31.120	86.70.31.120	Ban Giám hiệu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Nguyễn Khắc Thông
260	64:00:6a:3b:6c:07	192.168.52.42	192.168.52.42	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
261	c8:7f:54:57:a5:14	86.70.31.128	86.70.31.128	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
262	00:d8:61:6d:56:75	86.70.31.180	86.70.31.180	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
263	1c:1b:0d:1d:6a:f7	192.168.51.17	192.168.51.17	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
264	90:1b:0e:67:a4:36	192.168.34.112	192.168.34.112	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
265	d8:bb:c1:69:5a:12	192.168.36.109	192.168.36.109	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
266	f4:6d:04:75:cd:19	86.70.31.100	86.70.31.100	Khoa Kỹ thuật cơ sở-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Trần Xuân Thạnh
267	50:eb:f6:1d:bf:cd	86.70.31.150	86.70.31.150	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Nguyễn Thanh Sơn
268	04:42:1a:ac:e9:6b	86.70.31.72	86.70.31.72	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
269	70:85:c2:d2:5b:b6	86.70.31.60	86.70.31.60	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10240, 64-bit Edition)	Admin
270	18:c0:4d:65:12:4c	192.168.36.160	192.168.36.160	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
271	40:8d:5c:a1:86:d7	86.38.3.203	86.38.3.203	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
272	70:85:c2:b5:18:6f	86.70.31.37	86.70.31.37	Khoa Khoa học xã hội & Nhân văn-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Đoàn Trung Đạt
273	d0:50:99:5e:57:75	192.168.162.58	192.168.162.58	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
274	40:a8:f0:43:a2:93	192.168.34.109	192.168.34.109	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
275	d4:3d:7e:2d:c3:fc	192.168.34.15	192.168.34.15	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
276	64:00:6a:04:70:09	192.168.162.64	192.168.162.64	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
277	24:0b:2a:f1:bf:70	192.168.162.33	192.168.162.33	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
278	d8:bb:c1:69:59:ea	192.168.144.21	192.168.144.21	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
279	40:a8:f0:4b:da:12	192.168.36.171	192.168.36.171	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
280	d8:bb:c1:69:59:66	192.168.36.145	192.168.36.145	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
281	84:69:93:84:8f:ab	192.168.144.16	192.168.144.16	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
282	40:8d:5c:3b:90:47	192.168.36.24	192.168.36.24	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
283	3c:7c:3f:d6:ab:a3	86.70.31.71	86.70.31.71	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
284	2c:56:dc:73:b0:84	192.168.104.104	192.168.104.104	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
285	b4:2e:99:b5:37:49	192.168.6.100	192.168.6.100	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
286	24:0b:2a:f1:c3:d7	192.168.52.40	192.168.52.40	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
287	18:c0:4d:65:12:8a	192.168.36.188	192.168.36.188	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
288	74:d4:35:20:67:4c	192.168.80.11	192.168.80.11	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
289	c8:7f:54:67:2e:a0	192.168.36.126	192.168.36.126	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
290	70:85:c2:b5:18:65	86.70.31.119	86.70.31.119	Khoa Chỉ huy Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	Nguyễn Đình Chiểu
291	e4:54:e8:df:38:d2	192.168.123.11	192.168.123.11	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
292	24:0b:2a:f1:bf:35	192.168.36.149	192.168.36.149	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
293	00:e0:4c:07:b4:51	86.70.31.127	86.70.31.127	Khoa Khoa học xã hội & Nhân văn-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trần Xuân Hoàng
294	90:b1:1c:6e:de:a5	192.168.35.117	192.168.35.117	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
295	a8:a1:59:30:6e:34	192.168.49.32	192.168.49.32	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
296	24:0b:2a:f1:bf:09	192.168.104.9	192.168.104.9	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
297	40:a8:f0:57:99:a3	192.168.144.1	192.168.144.1	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
298	e4:54:e8:a4:d7:a9	192.168.162.25	192.168.162.25	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	Admin
299	dc:4a:3e:53:20:f9	192.168.52.27	192.168.52.27	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
300	e4:e7:49:46:ec:49	192.168.6.138	192.168.6.138	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
301	24:0b:2a:f1:c4:8b	192.168.144.12	192.168.144.12	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
302	00:1c:c0:34:78:6d	192.168.11.15	192.168.11.15	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
303	40:a8:f0:49:df:b0	192.168.144.4	192.168.144.4	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
304	24:0b:2a:f1:c1:55	192.168.162.34	192.168.162.34	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
305	70:b5:e8:31:7e:ee	192.168.123.17	192.168.123.17	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
306	24:0b:2a:f1:c7:f4	192.168.162.29	192.168.162.29	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
307	74:d4:35:dc:85:70	192.168.41.3	192.168.41.3	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
308	d0:27:88:33:92:bb	192.168.41.109	192.168.41.109	Ban Quân lực-Phòng Quân lực-Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Hữu Chính
309	24:0b:2a:f1:c0:c2	192.168.162.30	192.168.162.30	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
310	00:22:68:46:1f:1b	192.168.162.38	192.168.162.38	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	Admin
311	00:d8:61:9e:c9:54	192.168.6.120	192.168.6.120	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 32-bit Edition)	Admin
312	fc:aa:14:0b:7d:93	192.168.41.12	192.168.41.12	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
313	88:51:fb:3f:ed:e2	192.168.201.11	192.168.201.11	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10240, 64-bit Edition)	Admin
314	1c:1b:0d:91:7f:67	192.168.36.151	192.168.36.151	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
315	c0:25:a5:c7:0a:a5	192.168.123.22	192.168.123.22	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22000, 64-bit Edition)	Admin
316	24:0b:2a:f1:bb:c0	192.168.144.33	192.168.144.33	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
317	b0:7b:25:19:15:8b	192.168.123.21	192.168.123.21	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
318	78:45:c4:3f:7d:65	192.168.162.59	192.168.162.59	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	Admin
319	74:27:ea:c0:3c:11	192.168.123.12	192.168.123.12	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
320	74:86:e2:37:a2:14	192.168.52.32	192.168.52.32	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
321	50:eb:f6:1d:bf:cb	86.70.31.52	86.70.31.52	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
322	18:60:24:71:54:37	192.168.31.109	192.168.31.109	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
323	d0:27:88:da:f9:f7	192.168.104.41	192.168.104.41	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
324	74:56:3c:8e:60:a9	192.168.36.115	192.168.36.115	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
325	b0:83:fe:85:d3:ca	192.168.104.6	192.168.104.6	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
326	54:a0:50:df:0a:5b	86.70.31.74	86.70.31.74	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Admin
327	04:7c:16:7e:6d:61	192.168.52.28	192.168.52.28	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
328	d8:5e:d3:fb:7f:8c	192.168.104.30	192.168.104.30	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
329	04:42:1a:ed:88:0d	192.168.36.128	192.168.36.128	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
330	50:eb:f6:1d:bf:bb	86.70.31.66	86.70.31.66	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
331	58:11:22:9b:6f:c5	192.168.144.32	192.168.144.32	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
332	44:8a:5b:5c:37:05	192.168.52.68	192.168.52.68	Phòng Khoa học quân sự-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10240, 64-bit Edition)	Nguyễn Hồng Hà
333	00:e0:4c:50:09:04	192.168.52.20	192.168.52.20	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
334	8c:ec:4b:73:f9:35	192.168.123.19	192.168.123.19	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
335	4c:cc:6a:64:bd:a5	192.168.6.11	192.168.6.11	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
336	40:a8:f0:4b:dc:62	192.168.6.13	192.168.6.13	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
337	bc:30:5b:9f:0f:c7	192.168.51.15	192.168.51.15	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
338	e4:54:e8:a4:d9:6c	192.168.162.93	192.168.162.93	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
339	e4:54:e8:a4:d7:94	192.168.162.52	192.168.162.52	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	Admin
340	78:45:c4:10:43:a0	192.168.41.109	192.168.41.109	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
341	4c:cc:6a:68:ba:7b	86.70.31.69	86.70.31.69	Khoa Thiết bị Hàng không-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Thanh Văn
342	00:e0:4c:b0:b3:c3	86.70.31.35	86.70.31.35	Khoa Vô tuyến điện tử-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Thái Duy Hào
343	40:b0:34:39:ce:5b	192.168.34.27	192.168.34.27	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
344	e4:54:e8:5c:0e:2e	192.168.36.150	192.168.36.150	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
345	24:0b:2a:f1:be:21	192.168.162.51	192.168.162.51	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
346	e0:d5:5e:81:32:7e	192.168.36.108	192.168.36.108	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
347	b0:7b:25:17:08:a2	192.168.123.13	192.168.123.13	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
348	90:2b:34:cb:ab:ab	192.168.201.29	192.168.201.29	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
349	78:2b:cb:cd:e5:67	192.168.6.113	192.168.6.113	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trần Ngọc Hiệp
350	e4:54:e8:a4:db:94	192.168.162.32	192.168.162.32	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	Admin
351	14:dd:a9:d6:0a:52	192.168.6.128	192.168.6.128	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
352	50:eb:f6:1d:bf:bd	86.70.31.252	86.70.31.252	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
353	74:d4:35:2e:f1:b6	86.70.31.33	86.70.31.33	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	Admin
354	d8:5e:d3:f9:f1:6d	192.168.144.17	192.168.144.17	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
355	c0:25:a5:c7:09:df	192.168.123.23	192.168.123.23	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22000, 64-bit Edition)	Admin
356	30:d0:42:eb:d4:a5	86.70.31.233	86.70.31.233	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
357	40:a8:f0:4b:db:c8	192.168.36.111	192.168.36.111	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	PKLQ_KH_ThangTN
358	40:a8:f0:57:99:ad	192.168.104.122	192.168.104.122	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
359	50:9a:4c:17:8d:86	192.168.41.17	192.168.41.17	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
360	e4:54:e8:a4:d7:7c	192.168.162.60	192.168.162.60	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
361	6c:3c:8c:24:d5:6d	192.168.104.28	192.168.104.28	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
362	78:45:c4:3f:82:c5	192.168.201.134	192.168.201.134	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
363	f8:bc:12:77:2c:ee	192.168.36.97	192.168.36.97	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
364	74:56:3c:d2:b3:f8	192.168.79.71	192.168.79.71	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
365	1c:69:7a:d1:36:25	86.80.81.109	86.80.81.109	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
366	08:2e:5f:31:24:72	86.38.124.30	86.38.124.30	Khoa Tên Lửa-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bộ môn C75 khoa tên lửa
367	4c:52:62:a7:bb:fd	192.168.52.21	192.168.52.21	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
368	44:87:fc:da:72:d0	192.168.104.100	192.168.104.100	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
369	20:88:10:72:f6:5a	192.168.123.25	192.168.123.25	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	Admin
370	fc:aa:14:5d:be:0b	192.168.144.110	192.168.144.110	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
371	18:c0:4d:1f:51:12	192.168.51.24	192.168.51.24	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
372	24:0b:2a:f1:c3:71	192.168.11.23	192.168.11.23	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Admin
373	00:22:64:1b:dd:ec	192.168.36.169	192.168.36.169	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
374	bc:ae:c5:cf:20:48	192.168.36.21	192.168.36.21	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
375	50:9a:4c:32:a8:fa	192.168.123.14	192.168.123.14	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
376	50:9a:4c:15:ad:f5	192.168.41.19	192.168.41.19	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Admin
377	30:0e:d5:cf:58:f3	192.168.36.102	192.168.36.102	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
378	e4:54:e8:a4:d8:33	192.168.162.88	192.168.162.88	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Admin
379	70:b5:e8:30:9a:75	192.168.123.26	192.168.123.26	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
380	d8:5e:d3:42:6e:7e	192.168.144.42	192.168.144.42	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
381	54:a0:50:51:6d:97	192.168.162.41	192.168.162.41	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
382	b0:7b:25:28:70:f1	192.168.144.15	192.168.144.15	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
383	40:a8:f0:4b:dc:6e	192.168.104.4	192.168.104.4	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
384	c0:25:a5:a3:51:b0	192.168.144.15	192.168.144.15	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
385	90:b1:1c:99:23:46	192.168.41.106	192.168.41.106	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
386	64:51:06:5c:a6:4f	192.168.201.108	192.168.201.108	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
387	b8:97:5a:a4:6b:a8	192.168.6.94	192.168.6.94	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	Admin
388	10:78:d2:d8:ce:e5	192.168.41.107	192.168.41.107	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
389	00:26:9e:32:0c:6d	86.70.30.134	86.70.30.134	Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phan Đăng Thạnh
390	a4:1f:72:7d:60:91	192.168.36.187	192.168.36.187	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
391	b8:97:5a:85:a4:15	192.168.162.69	192.168.162.69	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
392	98:ee:cb:e5:c4:e1	192.168.104.27	192.168.104.27	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
393	30:0e:d5:bf:72:e0	192.168.104.79	192.168.104.79	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
394	d8:cb:8a:17:2c:2a	86.70.31.78	86.70.31.78	Khoa Quân sự Thể thao-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Bùi Quốc Tú
395	b8:97:5a:f8:a0:c2	192.168.162.65	192.168.162.65	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
396	9c:5c:8e:d3:7e:b6	192.168.36.113	192.168.36.113	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
397	b8:97:5a:a4:70:f6	192.168.36.123	192.168.36.123	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
398	c8:7f:54:57:a2:0a	86.70.31.117	86.70.31.117	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Admin
399	1c:6f:65:ef:88:d5	192.168.162.57	192.168.162.57	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
400	40:8d:5c:64:02:db	86.70.31.39	86.70.31.39	Trung tâm Huấn luyện Thực hành-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	Giang Tiến Khắc
401	e0:73:e7:bd:14:ed	192.168.79.50	192.168.79.50	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	Admin
402	e0:73:e7:bd:14:e7	192.168.79.70	192.168.79.70	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	Admin
403	a0:48:1c:77:4f:21	86.70.30.151	86.70.30.151	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
404	ec:eb:b8:9b:ae:48	192.168.2.20	192.168.2.20	Quan chung PKKQ	Windows Server 2012 R2 (Version 6.3, Build 9600, 64-bit Edition)	Ban CNTT QCPKKQ
405	00:1f:d0:1b:eb:ec	86.38.128.38	86.38.128.38	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	PCN1 PCT
406	3c:7c:3f:d6:a1:3e	86.70.30.154	86.70.30.154	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DC_1103_SQ.1
407	94:de:80:12:1c:9c	192.168.201.27	192.168.201.27	Lữ Đoàn 26-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	DC_LD26_TTLD_TMT
408	40:b0:76:5b:5f:4a	192.168.201.149	192.168.201.149	Lữ Đoàn 26-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DC_LU26_PTM_QUANLU
409	4c:52:62:23:b2:5c	86.70.30.253	86.70.30.253	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DC_1403_1
410	4c:52:62:26:c9:0a	86.70.30.39	86.70.30.39	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DC_1104_KQ.1
411	4c:ed:fb:78:c9:a9	86.70.30.25	86.70.30.25	Ban Giám hiệu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	Admin
412	4c:52:62:26:c9:4e	86.70.30.201	86.70.30.201	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trợ lý
413	4c:ed:fb:78:c8:99	86.70.30.84	86.70.30.84	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
414	4c:ed:fb:78:ce:4f	86.70.30.83	86.70.30.83	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Admin
415	dc:4a:3e:92:56:46	192.168.201.135	192.168.201.135	Lữ Đoàn 26-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DC_LD26_PKT_TLKT
416	00:03:0b:07:04:27	86.70.30.142	86.70.30.142	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	DC_TM-CANHVE-PC
417	00:30:67:38:37:2d	86.70.30.77	86.70.30.77	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	DC_1403_SQ.2
418	30:5a:3a:5a:b2:46	192.168.201.133	192.168.201.133	Lữ Đoàn 26-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DC_LD26_PTM_NGHINV
419	74:d4:35:d8:b4:99	192.168.36.130	192.168.36.130	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trần Anh Tuấn
420	d8:cb:8a:38:c1:4d	192.168.201.12	192.168.201.12	Lữ Đoàn 26-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	LD26_PTM_TBTC
421	64:51:06:35:bb:d6	192.168.201.140	192.168.201.140	Lữ Đoàn 26-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	LD26_MAYCHU
422	18:66:da:18:11:57	192.168.21.32	192.168.21.32	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phòng  ĐHB
423	24:0b:2a:f1:be:7b	192.168.11.20	192.168.11.20	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Phạm Cao Sánh
424	04:bf:1b:7f:4a:35	192.168.79.46	192.168.79.46	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trần Đình Hạnh
425	50:b7:c3:a9:c5:1e	86.38.124.59	86.38.124.59	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BM-CTCD-PPK
426	50:b7:c3:a8:69:55	192.168.80.12	192.168.80.12	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	PKKQ_ACC_VANTHU
427	74:56:3c:d2:b3:5b	192.168.79.47	192.168.79.47	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Nguyễn Văn Sơn
428	1c:1b:0d:27:fd:ae	86.70.30.209	86.70.30.209	Ban Bảo vệ An ninh-Phòng Chính trị-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	admin
429	00:e0:4f:05:f5:4a	86.80.28.112	86.80.28.112	Trung đoàn 915-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	QUANHUAN-E915
430	fc:aa:14:68:a3:ef	86.70.30.222	86.70.30.222	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-DFRHHEO
431	00:0c:29:ba:36:20	86.70.30.32	86.70.30.32	Trường SQKQ-Quan chung PKKQ		Định danh tạm
432	74:56:3c:1e:a1:f7	192.168.104.14	192.168.104.14	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	CCT-UBKT-VANTHU
433	a8:a1:59:30:6e:dd	192.168.51.25	192.168.51.25	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	PHONGNGHIEPVU_T
434	24:0b:2a:f1:c0:90	192.168.162.42	192.168.162.42	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-GI70GMD
435	3c:7c:3f:c2:95:90	86.70.31.63	86.70.31.63	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-7G9AFDI
436	90:fb:a6:3f:6c:f3	192.168.36.18	192.168.36.18	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_PCT_VIETNX
437	20:88:10:72:a8:7e	192.168.123.24	192.168.123.24	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	DESKTOP-8H24068
438	60:02:92:61:14:7e	192.168.41.3	192.168.41.3	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_QLVT_PMTUAN
439	24:0b:2a:f1:ba:0a	192.168.35.166	192.168.35.166	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_PQL_TRANGNM2
440	20:88:10:61:db:74	192.168.51.10	192.168.51.10	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	TM_VQ_VANTHU
441	40:8d:5c:f0:ee:55	192.168.31.110	192.168.31.110	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	\tADMIN-PC
442	70:4d:7b:63:dc:45	86.38.128.89	86.38.128.89	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Ban PK/PHCKT
443	40:a8:f0:4b:da:69	192.168.36.126	192.168.36.126	Quan chung PKKQ	Windows 7 (Version 6.1, Build 7600, 32-bit Edition)	PKLQ_TT_THAOVV
444	d4:3d:7e:f8:34:51	192.168.31.19	192.168.31.19	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	ADMINISTRATOR
445	bc:5f:f4:b5:55:43	192.168.162.52	192.168.162.52	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	CKT_PTMKH_NGHIT
446	00:25:11:31:88:5e	192.168.162.22	192.168.162.22	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	CKT_PTMKH_THONG
447	24:0b:2a:f1:c0:0e	192.168.6.119	192.168.6.119	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-GI70GMD
448	d4:3d:7e:f8:23:22	192.168.31.114	192.168.31.114	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_PDHB_SONDH
449	50:b7:c3:a4:9e:97	192.168.162.54	192.168.162.54	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-V4K8R9N
450	3c:7c:3f:d6:a6:a5	86.70.31.64	86.70.31.64	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-GFP1BOG
451	e0:73:e7:bd:10:bf	192.168.79.52	192.168.79.52	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	ADMIN-PC
452	30:0e:d5:cc:28:45	86.38.128.75	86.38.128.75	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Trưởng phòng KHQS
453	68:84:7e:91:70:a3	192.168.11.27	192.168.11.27	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DC_1505_QC.2
454	40:8d:5c:a6:d7:b2	192.168.36.118	192.168.36.118	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	THAOVV_PHOCUCTR
455	68:84:7e:91:6a:35	192.168.11.26	192.168.11.26	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	BTL-HIENNV
456	00:05:0e:0a:2d:1a	192.168.35.105	192.168.35.105	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Phạm Thị Mười BTC
457	14:b3:1f:16:41:0b	192.168.36.192	192.168.36.192	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	\tBTM_PCB_CHUYENT
458	58:11:22:10:73:63	86.70.30.79	86.70.30.79	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Định danh tạm
459	fc:34:97:b9:c1:0c	192.168.79.57	192.168.79.57	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ADMIN-PC
460	74:56:3c:d2:bd:92	192.168.79.69	192.168.79.69	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TUANNA_PTC
461	d8:5e:d3:f9:f1:6b	192.168.36.159	192.168.36.159	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_KHDT_THANHDQ
462	bc:5f:f4:8c:df:62	192.168.201.24	192.168.201.24	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	LD26_TTLD_PHUOC
463	f4:4d:30:9d:4c:0c	192.168.35.104	192.168.35.104	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_KHQS_THONT
464	6c:2b:59:e5:1b:49	192.168.79.60	192.168.79.60	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	TM_PTAICHINH_KI
465	f4:f1:9e:12:5e:f6	192.168.51.12	192.168.51.12	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BTM_QB_ANHTM
466	d0:27:88:21:f5:3b	86.70.30.178	86.70.30.178	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	\tPTM-DAO-PC
467	14:dd:a9:28:c2:ca	192.168.6.168	192.168.6.168	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	TM_CNTT_NGHIAND
468	a8:a1:59:30:6d:84	192.168.36.161	192.168.36.161	Phòng Tác chiến điện tử-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Trực ban Phòng Tác chiến điện tử
469	74:56:3c:ec:58:cc	86.70.30.22	86.70.30.22	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-2I6JKLD
470	90:1b:0e:cf:6f:39	86.38.120.11	86.38.120.11	Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 14393, 64-bit Edition)	SRVHVPK
471	34:64:a9:23:7a:b5	192.168.36.11	192.168.36.11	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	LD26_PTM_QUANBU
472	18:03:73:52:75:3f	86.70.30.79	86.70.30.79	Trường SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	D2-HOA-PC
473	f8:bc:12:81:48:e7	192.168.36.15	192.168.36.15	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BTM_CB_KHANHLV
474	00:e0:4c:cd:e4:e6	86.70.30.184	86.70.30.184	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	SQKQ_PDT_TVINH
475	a4:bb:6d:5c:7f:b7	192.168.144.27	192.168.144.27	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	ADMIN
476	18:c0:4d:39:aa:32	192.168.36.121	192.168.36.121	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	PKLQ_PTC_CHIENL
477	8c:ec:4b:c4:e6:fb	86.38.128.183	86.38.128.183	Khoa Thông Tin Tác Chiến Điện Tử-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	BM Binh khí
478	d8:bb:c1:69:5a:66	192.168.6.199	192.168.6.199	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ITK-20240605GZA
479	a8:a1:59:30:6e:30	192.168.36.153	192.168.36.153	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-1QD3I2N
480	04:42:1a:ed:88:79	192.168.36.93	192.168.36.93	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	PKLQ_QUANHUAN_A
481	d8:5e:d3:f9:e5:85	192.168.11.2	192.168.11.2	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TRUONG_VP
482	78:45:c4:1b:2a:27	192.168.11.6	192.168.11.6	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BTM_VP_THAO
483	fc:aa:14:11:7c:97	192.168.11.3	192.168.11.3	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	\tBTM_VP_HUNGNN
484	1c:1b:0d:07:ae:88	192.168.11.1	192.168.11.1	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	ADMIN
485	1c:1b:0d:05:63:56	192.168.11.5	192.168.11.5	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	LAM-PC
486	00:20:ed:ff:ff:ff	86.38.124.65	86.38.124.65	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
487	2c:fd:a1:72:31:97	192.168.11.10	192.168.11.10	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	BTM_VP_DIENPV
488	a8:a1:59:30:68:ae	192.168.36.170	192.168.36.170	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-1QD3I2N
489	00:1f:d0:cf:54:7c	86.70.31.79	86.70.31.79	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-0FKU40K
490	18:66:da:1a:bd:3f	192.168.25.106	192.168.25.106	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	SCH_K99
491	64:51:06:34:9f:cc	192.168.21.109	192.168.21.109	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	SCH-TBKT-VQ
492	d8:5e:d3:fb:7f:0c	192.168.104.87	192.168.104.87	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	CT_PCB_TRUCBAN
493	b8:97:5a:77:1b:b4	192.168.36.120	192.168.36.120	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	PKLQ_TACHIEN_NA
494	34:97:f6:7f:fc:8c	192.168.62.17	192.168.62.17	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	TM_DTHS_DUCNT
495	40:8d:5c:a3:a9:bf	192.168.36.132	192.168.36.132	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-43MIOAV
496	50:eb:f6:e7:88:51	86.38.128.67	86.38.128.67	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng ban Quân nhu
497	c4:34:6b:51:43:cc	192.168.104.109	192.168.104.109	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-H867GQ9
498	f4:f1:9e:12:5d:b4	192.168.51.18	192.168.51.18	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	QUANBAO_BTM_THA
499	1c:c1:de:5b:7e:fd	86.38.128.148	86.38.128.148	Tiểu Đoàn 7-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	dt_d7
500	70:5a:0f:4d:2e:21	192.168.52.26	192.168.52.26	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	\tTM_QL_PHONGPH
501	f4:b5:20:60:7e:68	192.168.144.18	192.168.144.18	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	DESKTOP-N4KQ0PJ
502	d8:bb:c1:69:59:51	192.168.144.20	192.168.144.20	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ADMIN-PC
503	f4:4d:30:e3:90:49	192.168.62.13	192.168.62.13	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM-DTHS-DIEUND
504	58:11:22:95:e9:82	192.168.62.20	192.168.62.20	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	\tTM_DTHD_THANHTT
505	34:97:f6:81:35:7b	192.168.62.19	192.168.62.19	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	BTM_DTHS_TIEPNC
506	34:97:f6:81:3e:a1	192.168.62.21	192.168.62.21	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	BTM_DTHS_THACHH
507	cc:96:e5:38:a6:81	192.168.104.72	192.168.104.72	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	VANND_HCHCKHTH_
508	4c:72:b9:08:39:c1	192.168.62.22	192.168.62.22	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_DTHS_TRANGDT
509	58:11:22:95:cf:4b	192.168.62.24	192.168.62.24	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_DTHS_TRUNGVP
510	58:11:22:95:e2:de	192.168.62.23	192.168.62.23	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ITK-20240705KUK
511	0a:e0:af:be:07:c9	86.70.31.60	86.70.31.60	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-E7S0A6E
512	00:e0:4c:36:01:10	192.168.35.115	192.168.35.115	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	BTM_PTC_MUOIPT
513	24:0b:2a:f1:bc:1b	192.168.31.33	192.168.31.33	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TT_BTM_TUANNP
514	24:0b:2a:f1:b9:4c	192.168.31.12	192.168.31.12	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	PTMT_HUNGTM
515	24:0b:2a:f1:c4:1a	192.168.31.36	192.168.31.36	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TT_BTM_SONVH
516	e8:9c:25:95:c8:ce	192.168.144.17	192.168.144.17	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	HC_TM_BTC
517	b8:97:5a:af:bb:a7	192.168.36.159	192.168.36.159	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	admin
518	60:45:cb:73:af:f4	192.168.31.32	192.168.31.32	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ADMINISTRATOR
519	10:ff:e0:43:0c:09	192.168.31.29	192.168.31.29	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BTM_PHH_THAOTX
520	00:15:5d:78:01:01	86.38.120.2	86.38.120.2	Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 14393, 64-bit Edition)	\tWSUS_DATABASE
521	74:56:3c:8e:60:28	192.168.144.50	192.168.144.50	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	HC-PDT-QUANGNV
522	48:4d:7e:ec:48:eb	192.168.24.20	192.168.24.20	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	SCH_QLVT_TH2
523	d8:9e:f3:15:07:5c	192.168.24.115	192.168.24.115	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	SCH_QLVT_TH1
524	ec:eb:b8:9b:6e:ac	192.168.4.10	192.168.4.10	Quan chung PKKQ	Windows Server 2012 R2 (Version 6.3, Build 9600, 64-bit Edition)	SERVER-HTTCDDH
525	90:1b:0e:99:1c:7b	192.168.4.251	192.168.4.251	Quan chung PKKQ	Windows Server 2012 R2 (Version 6.3, Build 9600, 64-bit Edition)	SERVER-NAS-02
526	00:0c:29:b4:4b:93	192.168.2.105	192.168.2.105	Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 17763, 64-bit Edition)	QL-864
527	c8:f7:50:ff:21:b9	192.168.41.4	192.168.41.4	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	BTM_PTT_THUPTA
528	04:7c:16:7e:6d:7f	192.168.52.44	192.168.52.44	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-203HOIB
529	4c:52:62:23:b2:9a	86.38.124.128	86.38.124.128	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-SJCS54C
530	f4:b5:20:26:fc:00	192.168.41.18	192.168.41.18	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BTM_PKT_NHUANVD
531	f4:b5:20:30:e8:f4	192.168.41.15	192.168.41.15	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	TM_KT_TRUCBAN
532	00:68:eb:bd:6d:81	192.168.79.67	192.168.79.67	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	THAODP_PTCHINH_
533	6c:2b:59:fb:31:f4	192.168.25.129	192.168.25.129	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	SCH_F377
534	b0:83:fe:7b:67:24	192.168.36.20	192.168.36.20	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_CB_THANHNT
535	98:ee:cb:e6:28:87	192.168.6.6	192.168.6.6	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Tàn kiếm Huon9
536	d8:bb:c1:69:5f:de	192.168.144.30	192.168.144.30	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TANLV_PDT_CHC
537	90:1b:0e:6e:57:54	192.168.4.12	192.168.4.12	Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 14393, 64-bit Edition)	SERVER_TCPKKQ
538	00:e8:01:4b:27:9b	192.168.201.25	192.168.201.25	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	LD26_D22_TAI
539	dc:4a:3e:94:f7:bc	192.168.201.148	192.168.201.148	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	L26
540	b8:97:5a:c9:bf:9a	192.168.201.39	192.168.201.39	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	L26
541	04:42:1a:a7:f3:47	192.168.104.5	192.168.104.5	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ADMIN-PC
542	20:88:10:61:da:85	192.168.21.21	192.168.21.21	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-2IRC5IG
543	f8:bc:12:8f:91:74	192.168.36.13	192.168.36.13	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BTM_CB_TUANPA
544	00:e0:4c:68:31:de	192.168.162.62	192.168.162.62	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	\tCKT-PVT-DUNGCHU
545	4c:52:62:3f:08:1e	192.168.11.8	192.168.11.8	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	TM_VP_TANQN
546	74:56:3c:9d:27:0e	192.168.11.10	192.168.11.10	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	TM_VP_TANQN2
547	b0:7b:25:28:72:b5	192.168.11.25	192.168.11.25	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	TOAN-PC
548	64:51:06:55:70:1e	192.168.201.13	192.168.201.13	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	L26
549	10:ff:e0:43:0d:d7	192.168.52.55	192.168.52.55	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	TM_KHQS_KIENDA
550	ec:a8:6b:f2:44:d9	192.168.52.47	192.168.52.47	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	BTM_KHQS_HUNGHV
551	00:08:02:10:1a:05	192.168.104.17	192.168.104.17	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TRUCBAN_BTC-PC
552	f4:f1:9e:12:5e:81	192.168.51.14	192.168.51.14	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_QB_GIAOBAN
553	4c:72:b9:b5:31:fd	192.168.51.2	192.168.51.2	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Nguyễn Xuân Han
554	a8:a1:59:30:68:b6	192.168.51.20	192.168.51.20	Phòng Tác chiến điện tử-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Phạm Hữu Điều
555	2c:56:dc:4f:43:c6	86.70.30.189	86.70.30.189	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	PDT-PC
556	24:0b:2a:f1:ba:65	192.168.41.16	192.168.41.16	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	BTM_QLVT_THUONG
557	6c:2b:59:fb:0f:57	192.168.24.14	192.168.24.14	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-7690QHF
558	f4:39:09:41:60:1d	192.168.79.55	192.168.79.55	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	HUONGTT_PTC_BTM
559	b0:7b:25:11:dc:f6	192.168.79.62	192.168.79.62	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ANHLT_PTC_BTM
560	2c:58:b9:8d:28:e3	192.168.79.61	192.168.79.61	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	BTM_PTCHINH_HUE
561	b0:7b:25:11:bd:31	192.168.79.54	192.168.79.54	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Hoàng Thị Hạnh
562	b4:2e:99:4b:73:8d	192.168.79.53	192.168.79.53	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	HALV_TAICHINH
563	00:0c:29:e8:e0:3b	86.38.120.4	86.38.120.4	Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 20348, 64-bit Edition)	FMC-BIG-SERVER0
564	90:1b:0e:99:99:30	86.38.120.1	86.38.120.1	Quan chung PKKQ	Windows Server 2012 R2 (Version 6.3, Build 9600, 64-bit Edition)	HVPKKQ
565	04:42:1a:96:e8:cf	86.38.128.14	86.38.128.14	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Phó Giám Đốc QS
566	8c:ec:4b:78:b6:38	192.168.36.16	192.168.36.16	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_CB_DUNGLV
567	54:bf:64:97:d9:48	192.168.52.41	192.168.52.41	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ADMIN
568	a4:1f:72:77:85:f7	192.168.41.202	192.168.41.202	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	BTM_PTT_TNDUNG
569	10:ff:e0:12:de:8e	192.168.36.112	192.168.36.112	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	CUCTRUONGPKLQ_T
570	c8:7f:54:57:a5:79	86.70.31.84	86.70.31.84	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-D3AD5D0
571	4c:cc:6a:68:bb:8d	86.70.31.175	86.70.31.175	Khoa Chỉ huy Tham mưu-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Đào Thiện Hùng
572	c8:7f:54:57:a3:bc	86.70.31.93	86.70.31.93	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-6F4FISF
573	c8:7f:54:57:a2:27	86.80.28.114	86.80.28.114	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-G7GHFR8
574	6c:3c:8c:24:d5:73	86.80.28.110	86.80.28.110	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-IR3BLNH
575	f0:2f:74:b2:e0:55	86.70.31.129	86.70.31.129	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	\tSQKQ-QSTT-LUYEN
576	3c:7c:3f:d6:b2:41	86.70.31.46	86.70.31.46	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	SQKQ-KCB-HIEU
577	f0:2f:74:b2:e1:50	86.80.28.116	86.80.28.116	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	LINH-PC
578	d8:5e:d3:fb:7e:ff	192.168.6.121	192.168.6.121	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	TM_THKH_TTBTM
579	b4:96:91:c4:5e:fd	86.80.28.218	86.80.28.218	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-JBTTNCA
580	c8:7f:54:57:a1:e2	86.70.31.58	86.70.31.58	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	NGA-KNN
581	d0:27:88:3e:bc:a1	192.168.41.112	192.168.41.112	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Đào ĐÌnh Thắng
582	d0:8e:79:0c:57:85	86.80.81.211	86.80.81.211	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-UOSJSV9
583	d8:bb:c1:e0:9c:0c	86.80.28.115	86.80.28.115	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-KTAP1TL
584	70:85:c2:b5:17:b3	86.70.31.121	86.70.31.121	Phòng Đào tạo-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Nguyễn Văn Minh
585	50:eb:f6:1d:bf:d1	86.70.31.131	86.70.31.131	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-Q5898A8
586	c8:7f:54:57:a5:22	86.70.31.111	86.70.31.111	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-C5ACED9
587	04:42:1a:ac:e8:25	86.70.31.32	86.70.31.32	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-O1FKAQB
588	30:d0:42:eb:a0:69	86.70.31.174	86.70.31.174	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Noname
589	6c:3c:8c:10:47:42	192.168.79.59	192.168.79.59	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	HOAVT_PTC_BTM
590	c8:7f:54:57:a0:d5	86.70.31.89	86.70.31.89	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-D3AD5D0
591	0c:9d:92:19:54:b4	86.70.31.51	86.70.31.51	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-GFP1BOG
592	00:e0:70:7d:b3:50	86.38.124.132	86.38.124.132	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	KHOQS
593	78:45:c4:38:a9:6e	86.38.124.137	86.38.124.137	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	DESKTOP-B2RU983
594	c8:7f:54:57:a6:6b	86.70.31.200	86.70.31.200	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-D3AD5D0
595	54:bf:64:5c:e9:4e	86.70.30.195	86.70.30.195	Quan chung PKKQ	Windows Server 2016 (Version 10.0, Build 14393, 64-bit Edition)	WIN-AQDSECDB112
596	98:40:bb:2b:79:10	192.168.144.19	192.168.144.19	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	HC-PDT-QUANGNV2
597	00:e0:70:7f:21:92	86.38.124.136	86.38.124.136	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	WIN-TV6DQJDBNVN
598	a0:66:10:bb:c6:d7	86.70.30.243	86.70.30.243	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	DESKTOP-J0FUBE9
599	44:8a:5b:d7:9c:4b	86.38.128.28	86.38.128.28	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	TLTH/PTMHC
600	24:0b:2a:f1:bd:0e	192.168.162.40	192.168.162.40	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ITK-20221114NUD
601	30:5a:3a:4b:a0:55	86.70.31.115	86.70.31.115	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	CHTM-NGOCNINH
602	08:bf:b8:a0:95:46	192.168.144.35	192.168.144.35	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	HC-PDT-HUYTN
603	f4:f1:9e:09:cd:54	192.168.41.9	192.168.41.9	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	TM_PTT_CHINHKD
604	fc:aa:14:50:3e:7a	192.168.144.26	192.168.144.26	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	\tHC_PDT_GIANGLT
605	74:27:ea:d6:be:3c	192.168.52.24	192.168.52.24	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_TTB_DONGBV
606	04:42:1a:ac:e9:2e	86.70.31.79	86.70.31.79	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-Q5898A8
607	c0:3f:d5:ff:66:b1	192.168.36.162	192.168.36.162	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_QHNT_HLKQ
608	00:e0:9d:36:0f:94	192.168.162.37	192.168.162.37	Phòng Vật tư-Cục Kĩ thuật-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Vương Viết Thành
609	40:a8:f0:49:e3:c7	192.168.31.107	192.168.31.107	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_PDN_TRUCBAN
610	18:66:da:1a:ba:e4	192.168.24.13	192.168.24.13	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	\tITK-20240822OKZ
611	20:88:10:85:3a:dc	86.70.30.239	86.70.30.239	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	DESKTOP-NRO6SGF
612	04:d9:f5:34:d2:d3	192.168.144.53	192.168.144.53	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	CHC_DT_VAN
613	b8:97:5a:a4:6f:64	192.168.6.112	192.168.6.112	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_HCHC_NVPHUOG
614	00:e0:4d:f5:d7:6c	192.168.6.98	192.168.6.98	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	TM_HCHC_HOPNT
615	64:51:06:60:80:36	192.168.6.18	192.168.6.18	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	WIN-U7660VIAHJF
616	e8:9c:25:2a:d4:bc	86.38.128.99	86.38.128.99	Hệ 1-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Hệ trưởng Hệ 1
617	f4:4d:30:9d:48:ac	86.38.124.140	86.38.124.140	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Nghiệp vụ thư viện Thi
618	00:e0:70:7d:b2:8a	86.38.124.134	86.38.124.134	Phòng KHQS-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Nghiệp vụ thư viện Thi
619	d8:9e:f3:03:8a:a3	192.168.11.19	192.168.11.19	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	VP_TTBTL_THAUBT
620	24:0b:2a:f1:c2:d7	192.168.11.25	192.168.11.25	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ITK-20240803OYB
621	00:e0:4c:36:04:e5	192.168.36.124	192.168.36.124	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BTM_CB_LIENVT
622	04:7c:16:8b:9f:aa	192.168.52.56	192.168.52.56	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
623	ec:79:49:31:f3:de	86.70.30.126	86.70.30.126	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	MT SQKQ
624	6c:2b:59:fb:04:8f	86.144.196.173	86.144.196.173	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
625	6c:2b:59:fb:32:68	86.144.176.35	86.144.176.35	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
626	ce:e0:4c:2a:11:6d	86.80.40.65	86.80.40.65	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
627	c0:25:a5:a4:7c:3d	86.82.12.30	86.82.12.30	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
628	24:0b:2a:f1:be:95	192.168.36.140	192.168.36.140	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
629	24:0b:2a:f1:c2:a9	192.168.104.22	192.168.104.22	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
630	24:0b:2a:f1:bb:0a	192.168.52.53	192.168.52.53	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
631	a0:66:10:bb:c6:e6	86.144.108.100	86.144.108.100	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
632	bc:5f:f4:b1:ff:f1	192.168.144.60	192.168.144.60	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
633	24:0b:2a:f1:b9:d5	192.168.11.28	192.168.11.28	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
634	10:7c:61:b5:59:09	86.38.128.12	86.38.128.12	Ban Giám Đốc-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Chính ủy
635	00:08:1c:08:2b:1c	86.70.30.28	86.70.30.28	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Định danh tạm
636	94:de:80:15:ce:13	192.168.201.26	192.168.201.26	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
695	50:65:f3:29:16:da	192.168.104.88	192.168.104.88	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
637	f4:4d:30:a4:5c:6a	86.38.128.113	86.38.128.113	Tiểu Đoàn 8-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	dt_d8
638	8c:ec:4b:b7:6b:bf	86.38.128.45	86.38.128.45	Tiểu đoàn huấn luyện-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	dt dHL
639	f4:4d:30:a0:c3:5a	86.38.128.114	86.38.128.114	Tiểu Đoàn 8-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	ctv_d8
640	10:7c:61:b3:98:33	86.38.124.58	86.38.124.58	Khoa Pháo Phòng Không -TLTT-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	BM Khí tài
641	40:a8:f0:49:e0:fd	192.168.36.127	192.168.36.127	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
642	18:d6:c7:05:48:88	86.38.128.106	86.38.128.106	Hệ 2-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Hệ trưởng
643	00:06:15:06:08:2e	86.70.30.56	86.70.30.56	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 15063, 64-bit Edition)	Định danh tạm
644	ec:aa:a0:19:36:84	192.168.144.22	192.168.144.22	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
645	4c:cc:6a:68:bb:6d	86.70.31.65	86.70.31.65	Khoa Thiết bị Hàng không-SQKQ-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Đỗ Tiến Lương
646	b8:ae:ed:b9:65:e9	86.38.128.141	86.38.128.141	Tiểu Đoàn 6-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	dp d6
647	58:11:22:30:cd:fa	86.38.128.187	86.38.128.187	Phòng Chính trị-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trợ lý Đảng ủy
648	a8:5e:45:11:54:e9	192.168.52.48	192.168.52.48	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
649	e4:54:e8:88:52:a6	86.38.128.66	86.38.128.66	Phòng TM-HC-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TB Tài chính
650	24:0b:2a:b7:e4:0a	192.168.162.91	192.168.162.91	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
651	24:0b:2a:b7:f5:5f	192.168.162.48	192.168.162.48	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
652	c4:65:16:16:e1:59	192.168.162.38	192.168.162.38	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
653	24:0b:2a:b7:e0:4f	192.168.144.53	192.168.144.53	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
654	24:0b:2a:b7:fb:3c	192.168.162.75	192.168.162.75	SƯ ĐOÀN PK375-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
655	24:0b:2a:b7:f7:82	192.168.144.55	192.168.144.55	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
656	4c:52:62:26:c9:64	86.70.30.153	86.70.30.153	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17133, 32-bit Edition)	Định danh tạm
657	b0:83:fe:b7:06:2a	86.70.30.228	86.70.30.228	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	MT SQKQ
658	24:0b:2a:b7:fb:3e	192.168.104.70	192.168.104.70	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
659	24:0b:2a:b7:e3:f4	192.168.104.36	192.168.104.36	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
660	24:0b:2a:b7:f8:35	192.168.6.133	192.168.6.133	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
661	24:0b:2a:b7:f8:c7	192.168.104.54	192.168.104.54	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
662	24:0b:2a:b7:e3:6d	192.168.11.22	192.168.11.22	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
663	24:0b:2a:b7:e3:21	192.168.104.51	192.168.104.51	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
664	24:0b:2a:b7:e4:2a	192.168.104.78	192.168.104.78	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
665	24:0b:2a:b7:fa:07	192.168.162.67	192.168.162.67	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
666	24:0b:2a:b7:e3:1c	192.168.144.38	192.168.144.38	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
667	24:0b:2a:b7:df:a3	192.168.162.63	192.168.162.63	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
668	24:0b:2a:b7:f9:3f	192.168.162.68	192.168.162.68	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
669	24:0b:2a:b7:fb:10	192.168.162.81	192.168.162.81	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
670	24:0b:2a:b7:e0:67	192.168.104.23	192.168.104.23	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
671	6c:2b:59:d4:92:5e	192.168.41.6	192.168.41.6	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
672	6c:2b:59:d4:9f:1d	192.168.41.7	192.168.41.7	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
673	24:0b:2a:b7:f5:82	192.168.31.15	192.168.31.15	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
674	f4:4d:30:0f:ad:07	86.70.30.182	86.70.30.182	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
675	d0:ad:08:e8:04:ce	192.168.6.99	192.168.6.99	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
676	2c:44:fd:2b:d5:66	192.168.104.21	192.168.104.21	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
677	24:0b:2a:b7:f8:88	192.168.11.21	192.168.11.21	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
678	0a:e0:af:a7:07:56	86.70.30.204	86.70.30.204	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	
679	00:e0:4c:68:11:44	192.168.79.40	192.168.79.40	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
680	00:e6:02:01:65:59	192.168.6.129	192.168.6.129	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
681	6c:2b:59:fa:f6:3e	86.70.30.79	86.70.30.79	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
682	4c:52:62:28:ff:dd	86.80.28.120	86.80.28.120	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
683	60:cf:84:a4:20:87	86.70.30.235	86.70.30.235	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Định danh tạm
684	b0:83:fe:a0:50:4b	192.168.104.38	192.168.104.38	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
685	50:9a:4c:0c:dd:24	192.168.104.45	192.168.104.45	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
686	98:40:bb:3a:63:51	86.38.128.191	86.38.128.191	Tiểu Đoàn 7-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	CTV d7
687	60:cf:84:a4:1f:6a	86.70.30.164	86.70.30.164	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	MT SQKQ
688	18:66:da:32:3a:db	192.168.104.85	192.168.104.85	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
689	60:cf:84:a4:21:5a	86.70.30.108	86.70.30.108	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	MT SQKQ
690	54:bf:64:81:2b:04	192.168.104.48	192.168.104.48	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	
691	dc:fe:07:0b:00:8b	192.168.104.106	192.168.104.106	Cục Chính trị-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	CCT_BPN_NPLAN
692	74:d0:2b:ca:d8:f3	192.168.104.20	192.168.104.20	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
693	34:17:eb:d3:fa:19	192.168.36.156	192.168.36.156	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
696	10:7c:61:b5:59:02	86.38.124.139	86.38.124.139	Phòng Đào tạo-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng ban Vật tư Huấn luyện
697	1c:1b:0d:ab:75:24	192.168.104.49	192.168.104.49	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
698	24:0b:2a:f1:c5:28	192.168.104.82	192.168.104.82	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
699	74:56:3c:81:da:24	192.168.104.55	192.168.104.55	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
700	98:ee:cb:e6:40:37	192.168.104.56	192.168.104.56	Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	
701	74:27:ea:aa:a7:6b	192.168.104.15	192.168.104.15	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
702	24:0b:2a:f1:bc:83	192.168.104.58	192.168.104.58	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
703	10:7c:61:b5:58:79	86.38.124.79	86.38.124.79	Khoa Khoa Học Cơ Bản-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng khoa
704	24:0b:2a:b7:f5:e9	192.168.36.158	192.168.36.158	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
705	24:0b:2a:b7:f6:43	192.168.36.134	192.168.36.134	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
706	60:cf:84:a4:1e:7c	86.70.30.243	86.70.30.243	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	MT SQKQ
707	10:7c:61:b5:59:ca	86.38.124.42	86.38.124.42	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
708	90:1b:0e:e1:d1:ff	192.168.104.40	192.168.104.40	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
709	d0:8e:79:09:24:7b	192.168.104.39	192.168.104.39	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
710	00:e0:4c:0c:0e:43	192.168.104.59	192.168.104.59	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
711	a8:a1:59:07:d7:b6	192.168.104.44	192.168.104.44	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
712	e4:54:e8:a4:9c:65	192.168.104.61	192.168.104.61	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	
713	74:56:3c:1e:fa:c7	192.168.104.80	192.168.104.80	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
714	24:0b:2a:b7:fa:4d	192.168.104.62	192.168.104.62	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
715	0a:e0:af:ca:4b:f2	192.168.104.13	192.168.104.13	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	
716	f4:b5:20:69:56:65	192.168.104.64	192.168.104.64	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
717	10:ff:e0:4c:f3:f5	86.70.30.244	86.70.30.244	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	MT SQKQ
718	38:2c:4a:e8:6f:d3	192.168.104.75	192.168.104.75	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
719	24:0b:2a:b7:e2:37	192.168.104.74	192.168.104.74	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
720	34:17:eb:9c:43:e7	192.168.104.43	192.168.104.43	Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	
721	9c:b6:54:ea:38:8f	192.168.104.68	192.168.104.68	Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	
722	20:47:47:3e:27:64	192.168.104.46	192.168.104.46	Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	
723	50:e5:49:e7:b1:d7	192.168.104.16	192.168.104.16	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
724	20:47:47:3e:28:18	192.168.104.71	192.168.104.71	Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	
725	d4:5d:64:00:45:f6	192.168.104.73	192.168.104.73	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
726	00:e0:21:4d:a8:87	86.70.30.40	86.70.30.40	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	MT SQKQ
727	60:cf:84:a4:1f:16	86.70.31.79	86.70.31.79	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
728	f4:4d:30:4b:f4:df	86.70.30.196	86.70.30.196	Phòng Tham mưu-SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	MT SQKQ
729	00:e0:21:5e:82:38	192.168.104.18	192.168.104.18	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
730	50:9a:4c:29:26:5e	192.168.52.50	192.168.52.50	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
731	10:ff:e0:0c:a1:75	192.168.79.63	192.168.79.63	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
732	4c:d7:17:9f:9d:fe	192.168.79.44	192.168.79.44	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
733	24:0b:2a:b7:fb:a2	192.168.31.32	192.168.31.32	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
734	24:0b:2a:b7:e8:0c	192.168.31.30	192.168.31.30	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
735	24:0b:2a:b7:df:67	192.168.31.47	192.168.31.47	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
736	2c:f0:5d:28:bb:75	192.168.36.172	192.168.36.172	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
737	60:cf:84:a4:1f:54	86.70.30.50	86.70.30.50	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	MT SQKQ
738	40:a8:f0:4b:dd:19	192.168.162.23	192.168.162.23	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
739	40:8d:5c:66:38:61	192.168.36.18	192.168.36.18	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
740	f8:0f:41:b4:2c:50	192.168.162.45	192.168.162.45	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
741	00:e0:6b:32:02:d3	86.38.128.92	86.38.128.92	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
742	60:cf:84:6a:32:ea	86.70.30.205	86.70.30.205	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	MT SQKQ
743	d8:5e:d3:f9:ed:0a	86.70.30.173	86.70.30.173	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
744	00:25:ab:6a:a5:dc	192.168.52.37	192.168.52.37	Phòng Quân lực-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 16299, 64-bit Edition)	NHÂM TUẤN ANH
745	94:c6:91:6b:96:71	86.38.128.68	86.38.128.68	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Trưởng Ban Quân Y
746	60:cf:84:80:c0:68	192.168.104.57	192.168.104.57	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
747	50:9a:4c:56:99:5b	192.168.41.12	192.168.41.12	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
748	ac:22:0b:cb:a0:49	192.168.36.107	192.168.36.107	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
749	e4:54:e8:e4:7b:f8	192.168.41.13	192.168.41.13	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
750	cc:28:aa:37:fc:c9	192.168.144.11	192.168.144.11	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
751	34:64:a9:36:54:d6	192.168.81.18	192.168.81.18	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
752	60:cf:84:a4:20:ba	86.70.30.134	86.70.30.134	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Định danh tạm
753	00:e0:4c:bd:02:56	86.80.81.109	86.80.81.109	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
754	c0:3f:d5:ff:69:05	86.38.128.148	86.38.128.148	Tiểu Đoàn 7-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Tiểu đoàn trưởng d7
755	74:86:7a:6e:8e:6f	192.168.81.111	192.168.81.111	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
756	60:cf:84:a4:20:9d	86.80.28.128	86.80.28.128	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
757	24:6a:0e:80:41:d1	192.168.36.94	192.168.36.94	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
758	24:0b:2a:b7:f6:4a	192.168.31.25	192.168.31.25	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
759	24:0b:2a:b7:e9:e2	192.168.31.23	192.168.31.23	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
760	24:0b:2a:b7:fb:5c	192.168.31.27	192.168.31.27	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
761	80:e8:2c:d4:ea:87	192.168.36.136	192.168.36.136	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
762	64:51:06:60:85:15	192.168.201.140	192.168.201.140	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
763	f4:8e:38:93:2d:47	192.168.52.60	192.168.52.60	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
764	10:98:19:28:16:9b	192.168.31.40	192.168.31.40	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
765	24:0b:2a:b7:fa:72	192.168.31.35	192.168.31.35	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
766	24:0b:2a:f1:c0:00	192.168.201.53	192.168.201.53	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
767	a4:1f:72:71:db:c7	86.70.30.159	86.70.30.159	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
768	24:0b:2a:f1:bf:e9	192.168.104.33	192.168.104.33	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
769	f4:8e:38:bc:32:c0	86.38.128.69	86.38.128.69	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Ban Doanh Trại
770	58:11:22:9d:d1:4e	192.168.36.174	192.168.36.174	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
771	b8:97:5a:af:bf:a2	192.168.36.175	192.168.36.175	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
772	00:e0:4e:f0:58:c9	192.168.36.114	192.168.36.114	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
773	18:c0:4d:1f:55:6d	192.168.36.176	192.168.36.176	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
774	60:cf:84:a4:1f:cf	86.70.30.225	86.70.30.225	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
775	64:51:06:34:02:ec	192.168.36.177	192.168.36.177	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
776	1c:6f:65:e6:2c:69	192.168.36.101	192.168.36.101	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
777	24:0b:2a:b7:fa:0e	192.168.11.29	192.168.11.29	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
778	d8:bb:c1:4c:73:d4	192.168.104.67	192.168.104.67	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
779	18:66:da:18:21:72	192.168.6.129	192.168.6.129	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
780	a0:66:10:bb:c6:62	86.70.30.201	86.70.30.201	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
781	74:56:3c:1e:a1:d1	192.168.36.104	192.168.36.104	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
782	00:22:68:86:19:61	192.168.144.23	192.168.144.23	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
783	60:cf:84:a4:22:9b	86.70.30.28	86.70.30.28	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Định danh tạm
784	ec:8e:b5:d6:b8:81	86.38.128.90	86.38.128.90	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
785	98:ee:cb:e5:91:06	192.168.6.97	192.168.6.97	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	
786	40:b0:34:2d:13:2d	192.168.104.96	192.168.104.96	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
787	f4:f1:9e:0b:89:5d	192.168.41.11	192.168.41.11	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
788	00:d8:61:6d:58:5b	86.70.30.222	86.70.30.222	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Định danh tạm
789	9c:6b:00:8b:f4:04	86.38.128.65	86.38.128.65	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Trưởng ban Doanh trại
790	f8:bc:12:89:cf:61	192.168.52.63	192.168.52.63	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
791	f8:bc:12:89:cc:8e	192.168.52.38	192.168.52.38	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
792	f0:79:59:8e:bc:ea	192.168.52.64	192.168.52.64	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
793	18:03:73:29:d5:45	192.168.31.42	192.168.31.42	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
794	10:98:19:27:f9:e8	192.168.31.53	192.168.31.53	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
795	10:98:19:27:f9:84	192.168.31.37	192.168.31.37	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
796	10:98:19:27:f9:3e	192.168.31.43	192.168.31.43	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
797	24:0b:2a:b7:f6:c5	192.168.11.30	192.168.11.30	Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Phạm Tuấn Anh
798	10:98:19:28:07:1f	192.168.31.38	192.168.31.38	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
799	b8:ca:3a:a9:1c:59	192.168.52.67	192.168.52.67	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
800	18:c0:4d:40:ad:f8	192.168.201.21	192.168.201.21	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
801	00:71:c2:0a:7f:42	192.168.107.23	192.168.107.23	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
802	f4:8e:38:85:89:59	192.168.106.22	192.168.106.22	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
803	d0:50:99:c2:8f:ea	192.168.6.135	192.168.6.135	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
804	18:c0:4d:5a:d4:df	192.168.6.146	192.168.6.146	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
805	00:1c:c0:52:5e:48	192.168.6.153	192.168.6.153	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
806	dc:4a:3e:53:1f:0d	192.168.52.69	192.168.52.69	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
807	00:10:f3:a5:fa:ee	192.168.51.23	192.168.51.23	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
808	00:10:f3:a9:7c:f1	192.168.51.17	192.168.51.17	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
809	e8:03:9a:69:3c:ba	86.38.128.72	86.38.128.72	Phòng Hậu Cần  - Kỹ thuật -Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	Bệnh xá
810	cc:28:aa:37:fc:03	192.168.144.46	192.168.144.46	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
811	9c:5c:8e:bd:48:83	192.168.144.48	192.168.144.48	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
812	74:d4:35:c1:6a:20	192.168.36.178	192.168.36.178	Phòng Kế hoạch đầu tư-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	TM_KHDT_TrBan
813	04:7c:16:d6:9d:68	192.168.144.51	192.168.144.51	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
814	04:42:1a:ae:4e:ca	192.168.144.52	192.168.144.52	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
815	00:23:24:06:96:04	192.168.144.54	192.168.144.54	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
816	e4:54:e8:5c:18:aa	192.168.201.24	192.168.201.24	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
817	e4:54:e8:5c:1a:7f	192.168.201.25	192.168.201.25	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
818	d0:8e:79:0c:57:01	192.168.201.27	192.168.201.27	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
819	00:cf:e0:54:f6:fc	192.168.201.28	192.168.201.28	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
820	14:58:d0:ca:25:a7	86.70.30.36	86.70.30.36	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
821	00:30:67:d8:ea:42	86.38.128.190	86.38.128.190	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
822	a4:1f:72:76:b5:4f	192.168.201.29	192.168.201.29	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
823	a4:1f:72:76:b5:0e	192.168.201.30	192.168.201.30	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
824	78:45:c4:0e:89:b2	192.168.201.62	192.168.201.62	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
825	78:45:c4:1e:ad:95	192.168.201.32	192.168.201.32	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
826	78:45:c4:0e:81:c8	192.168.201.31	192.168.201.31	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
827	00:71:c2:46:9b:d4	86.38.128.30	86.38.128.30	Phòng TM-HC-Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	TB Tác chiến
828	78:45:c4:0e:80:8b	192.168.201.35	192.168.201.35	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
829	78:45:c4:0e:95:24	192.168.201.52	192.168.201.52	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
830	fc:aa:14:36:e3:38	192.168.52.43	192.168.52.43	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
831	e4:54:e8:5c:0d:dc	192.168.201.38	192.168.201.38	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
832	b8:97:5a:ab:ce:dc	86.38.128.49	86.38.128.49	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
833	50:eb:f6:df:46:77	192.168.81.21	192.168.81.21	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
834	d8:bb:c1:48:f4:a5	192.168.52.73	192.168.52.73	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
835	8c:ec:4b:ad:00:ad	192.168.52.75	192.168.52.75	Quan chung PKKQ	Windows 10 (Version 10.0, Build 10586, 64-bit Edition)	
836	1c:1b:0d:8b:b0:10	192.168.201.11	192.168.201.11	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
837	10:98:19:28:0c:57	192.168.31.36	192.168.31.36	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
838	b4:96:91:c8:57:1a	86.80.40.71	86.80.40.71	Sư đoàn 377-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	Định danh tạm
839	78:45:c4:0e:7b:7b	192.168.201.40	192.168.201.40	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
840	10:e7:c6:af:e7:25	175.108.105.58	175.108.105.58	Trạm Ra đa 32-Trung đoàn 294-Sư đoàn 367-Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	Triệu Quang Hải
841	40:b0:34:f6:fc:76	175.108.104.50	175.108.104.50	Trạm Ra đa 30-Trung đoàn 294-Sư đoàn 367-Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	Nguyễn Long Hồ
842	10:ff:e0:98:ce:ed	86.80.81.220	86.80.81.220	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
843	60:cf:84:a4:22:32	86.80.81.250	86.80.81.250	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
844	10:ff:e0:99:56:1e	86.80.81.249	86.80.81.249	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
845	10:ff:e0:99:55:bd	86.80.81.248	86.80.81.248	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
846	60:cf:84:dc:43:62	86.80.28.136	86.80.28.136	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
847	e0:d5:5e:85:12:f2	86.80.28.119	86.80.28.119	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
848	04:d4:c4:a9:e8:d9	86.80.28.248	86.80.28.248	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
849	04:d4:c4:a9:e8:23	86.80.28.118	86.80.28.118	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
850	c8:7f:54:57:a4:e2	86.80.28.134	86.80.28.134	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
851	b8:97:5a:14:d3:28	192.168.36.100	192.168.36.100	Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	
852	e0:d5:5e:85:1a:c7	86.80.28.127	86.80.28.127	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
853	1c:1b:0d:69:84:47	192.168.36.135	192.168.36.135	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
854	34:17:eb:d9:77:92	192.168.36.142	192.168.36.142	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
855	04:92:26:5d:a8:c0	192.168.52.25	192.168.52.25	Quan chung PKKQ	Windows 10 (Version 10.0, Build 14393, 64-bit Edition)	
856	04:d4:c4:a9:e1:62	86.80.28.124	86.80.28.124	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
857	04:d4:c4:a9:eb:3d	86.80.28.129	86.80.28.129	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
858	04:d4:c4:a9:e1:4d	86.80.28.130	86.80.28.130	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
859	c8:7f:54:57:a2:23	86.80.28.133	86.80.28.133	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
860	b0:6e:bf:2d:73:ea	192.168.107.22	192.168.107.22	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
861	3c:52:82:5c:5a:72	192.168.52.71	192.168.52.71	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
862	60:cf:84:d9:91:df	86.70.31.65	86.70.31.65	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
863	50:b7:c3:ad:51:6f	86.80.28.126	86.80.28.126	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
864	6c:3c:8c:02:3e:8e	192.168.41.3	192.168.41.3	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
865	c0:25:a5:c2:11:34	192.168.104.32	192.168.104.32	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
866	40:b0:34:2d:11:a3	192.168.104.76	192.168.104.76	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17134, 64-bit Edition)	
867	1c:1b:0d:65:f7:be	86.80.28.130	86.80.28.130	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	
868	24:0b:2a:f1:c6:b8	192.168.6.93	192.168.6.93	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
869	18:c0:4d:06:01:46	192.168.6.106	192.168.6.106	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
870	18:c0:4d:06:01:1e	192.168.6.113	192.168.6.113	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
871	6c:3c:8c:3a:b4:68	192.168.6.128	192.168.6.128	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
872	b8:97:5a:f8:a6:56	192.168.6.126	192.168.6.126	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
873	04:7c:16:7e:6d:6d	192.168.6.131	192.168.6.131	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
874	d8:43:ae:c6:cc:ee	86.80.28.135	86.80.28.135	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
875	18:c0:4d:06:0c:cf	192.168.6.145	192.168.6.145	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
876	b8:97:5a:f8:a6:73	192.168.6.147	192.168.6.147	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
877	f8:bc:12:a1:ba:af	86.70.30.211	86.70.30.211	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
878	78:45:c4:3f:81:b8	192.168.41.102	192.168.41.102	Bộ Tham mưu-Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	Admin
879	a0:66:10:bb:c6:78	86.70.30.234	86.70.30.234	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Định danh tạm
880	64:00:6a:32:38:a0	192.168.36.143	192.168.36.143	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
881	00:e0:4c:36:16:46	192.168.81.11	192.168.81.11	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 64-bit Edition)	
882	c8:d3:ff:b4:17:b9	192.168.52.77	192.168.52.77	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
883	74:56:3c:6d:05:dc	192.168.79.45	192.168.79.45	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
884	c0:3f:d5:af:87:ff	86.70.30.172	86.70.30.172	Trường SQKQ-Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	Định danh tạm
885	dc:4a:3e:41:c7:cc	192.168.52.76	192.168.52.76	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
886	74:56:3c:6d:05:5a	192.168.79.48	192.168.79.48	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
887	a0:8c:fd:c2:9a:ab	192.168.52.82	192.168.52.82	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
888	8c:47:be:21:67:5f	86.40.240.251	86.40.240.251	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	DESKTOP-MP69CIQ
889	c8:7f:54:c6:6a:4f	192.168.36.125	192.168.36.125	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
890	00:68:eb:af:98:03	192.168.104.77	192.168.104.77	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
891	00:25:22:f3:ec:b5	86.80.28.123	86.80.28.123	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
892	e4:54:e8:a4:a0:e7	192.168.104.80	192.168.104.80	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
893	00:be:43:db:89:84	192.168.79.46	192.168.79.46	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
894	54:bf:64:9a:1e:44	192.168.79.65	192.168.79.65	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
895	74:56:3c:d2:b3:f6	192.168.79.42	192.168.79.42	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
896	d8:cb:8a:f6:95:8d	192.168.36.184	192.168.36.184	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
897	10:ff:e0:98:cf:9b	86.80.81.112	86.80.81.112	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
898	10:ff:e0:98:cf:76	86.80.81.160	86.80.81.160	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
899	94:de:80:75:bc:db	192.168.162.79	192.168.162.79	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
900	e4:54:e8:a4:d8:5c	192.168.162.80	192.168.162.80	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
901	24:0b:2a:b7:f7:eb	192.168.25.42	192.168.25.42	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
902	f8:bc:12:9f:0a:b4	86.70.30.211	86.70.30.211	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
903	6c:3c:8c:17:04:63	86.80.81.246	86.80.81.246	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
904	10:ff:e0:98:d0:22	86.80.81.225	86.80.81.225	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
905	10:ff:e0:98:cf:74	86.80.81.226	86.80.81.226	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
906	22:43:5c:05:01:e8	86.80.81.227	86.80.81.227	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
907	ec:75:0c:9f:eb:f9	86.70.31.247	86.70.31.247	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
908	10:ff:e0:98:cf:6e	86.80.81.242	86.80.81.242	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
909	10:ff:e0:98:cd:b2	86.80.81.115	86.80.81.115	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
910	10:ff:e0:98:cd:b7	86.80.81.235	86.80.81.235	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
911	10:ff:e0:98:d4:bd	86.80.81.240	86.80.81.240	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
912	e4:54:e8:db:31:34	192.168.104.17	192.168.104.17	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
913	10:ff:e0:98:d6:9c	86.80.81.245	86.80.81.245	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
914	fc:aa:14:98:81:f0	192.168.31.42	192.168.31.42	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
915	e4:54:e8:cb:26:17	192.168.104.86	192.168.104.86	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
916	70:8b:cd:55:a9:28	86.70.30.54	86.70.30.54	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
917	e4:7f:b2:16:d9:24	192.168.104.88	192.168.104.88	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
918	00:03:14:13:09:29	86.70.30.56	86.70.30.56	Quan chung PKKQ	Windows 10 (Version 10.0, Build 15063, 64-bit Edition)	
919	10:ff:e0:98:d6:28	86.80.28.121	86.80.28.121	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
920	20:88:10:83:9c:80	192.168.201.42	192.168.201.42	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
921	20:88:10:83:9e:55	192.168.201.43	192.168.201.43	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
922	10:ff:e0:98:d1:c8	86.80.28.247	86.80.28.247	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
923	20:88:10:83:9d:d9	192.168.201.45	192.168.201.45	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
924	7c:57:58:ce:07:f1	192.168.201.37	192.168.201.37	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
925	7c:57:58:ce:09:6f	192.168.201.50	192.168.201.50	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
926	00:03:15:02:03:28	86.70.30.56	86.70.30.56	Quan chung PKKQ	Windows 10 (Version 10.0, Build 15063, 64-bit Edition)	
927	20:88:10:83:a1:6b	192.168.201.44	192.168.201.44	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
928	b4:2e:99:52:5c:c9	192.168.6.89	192.168.6.89	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
929	6c:3c:8c:37:69:1e	192.168.31.51	192.168.31.51	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
930	20:88:10:81:7f:a5	192.168.201.46	192.168.201.46	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
931	20:88:10:83:a1:0c	192.168.201.47	192.168.201.47	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
932	24:0b:2a:f1:b9:97	192.168.11.12	192.168.11.12	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
933	d8:5e:d3:fb:7f:04	192.168.36.111	192.168.36.111	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
934	7c:57:58:c5:77:98	192.168.36.139	192.168.36.139	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
935	00:24:1d:36:87:6d	192.168.36.14	192.168.36.14	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
936	98:90:96:d5:e7:6a	192.168.36.119	192.168.36.119	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
937	90:2b:34:40:d4:64	86.80.40.72	86.80.40.72	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
938	98:ee:cb:27:8f:b8	192.168.31.46	192.168.31.46	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
939	40:b0:76:5b:5b:4c	192.168.6.130	192.168.6.130	Phòng Quân lực-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	TM_PQL_BINHQLBTM
940	e0:d5:5e:40:e5:64	86.70.80.150	86.70.80.150	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
941	00:1f:d0:c0:22:62	86.80.224.224	86.80.224.224	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
942	dc:4a:3e:53:1f:73	192.168.52.23	192.168.52.23	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
943	50:9a:4c:57:72:bf	192.168.6.92	192.168.6.92	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
944	00:10:f3:a9:7b:68	175.103.123.13	175.103.123.13	Quan chung PKKQ	Windows 8.1 (Version 6.3, Build 9600, 64-bit Edition)	
945	30:5a:3a:5a:cc:26	86.144.176.221	86.144.176.221	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
946	74:56:3c:d2:c0:7b	192.168.79.58	192.168.79.58	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
947	b0:83:fe:95:c0:3a	86.38.3.203	86.38.3.203	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
948	50:eb:f6:78:ab:88	192.168.36.98	192.168.36.98	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
949	00:10:f3:a9:7b:69	175.103.123.218	175.103.123.218	Quan chung PKKQ	Windows 8.1 (Version 6.3, Build 9600, 64-bit Edition)	
950	b8:ae:ed:af:2b:9c	86.38.128.190	86.38.128.190	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
951	dc:4a:3e:9a:40:aa	192.168.201.36	192.168.201.36	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
952	30:85:a9:3a:ff:fb	192.168.201.48	192.168.201.48	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
953	20:88:10:83:a1:37	192.168.201.49	192.168.201.49	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
954	d8:50:e6:bb:5e:f4	192.168.81.103	192.168.81.103	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
955	c8:1f:66:b3:2d:7f	192.168.162.86	192.168.162.86	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
956	5c:f9:dd:dc:2c:10	192.168.162.87	192.168.162.87	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
957	60:cf:84:6a:7b:a9	86.38.128.190	86.38.128.190	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
958	00:21:70:69:fd:09	192.168.162.73	192.168.162.73	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
959	c8:1f:66:b3:2d:46	192.168.162.75	192.168.162.75	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
960	5c:f9:dd:e8:4f:83	192.168.162.37	192.168.162.37	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
961	a4:bb:6d:47:f4:5e	192.168.162.79	192.168.162.79	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
962	5c:f9:dd:db:db:d3	192.168.162.76	192.168.162.76	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
963	60:cf:84:6a:48:bc	86.38.128.51	86.38.128.51	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
964	60:cf:84:6a:30:55	86.38.128.74	86.38.128.74	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
965	60:cf:84:6a:30:14	86.38.128.14	86.38.128.14	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
966	58:11:22:d4:42:74	86.80.81.118	86.80.81.118	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
967	dc:4a:3e:94:f6:f0	192.168.201.22	192.168.201.22	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
968	6c:3c:8c:37:66:7e	192.168.31.24	192.168.31.24	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
969	10:7c:61:b3:87:a5	86.38.124.92	86.38.124.92	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
970	50:9a:4c:47:5c:c0	192.168.31.12	192.168.31.12	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
971	1c:1b:0d:05:97:59	192.168.201.60	192.168.201.60	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
972	60:cf:84:6a:7b:a5	86.38.128.34	86.38.128.34	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
973	4c:52:62:0f:94:2f	192.168.12.11	192.168.12.11	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
974	90:b1:1c:67:cd:3d	192.168.201.63	192.168.201.63	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
975	60:cf:84:6a:7b:42	86.38.128.190	86.38.128.190	Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
976	14:b3:1f:22:57:dc	192.168.201.65	192.168.201.65	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
977	64:51:06:38:62:67	192.168.201.66	192.168.201.66	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
978	bc:fc:e7:64:a8:7a	192.168.36.189	192.168.36.189	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
979	a0:d3:c1:09:7b:50	192.168.31.45	192.168.31.45	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
980	d0:27:88:c5:90:70	192.168.201.68	192.168.201.68	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
981	60:cf:84:6a:7b:43	86.38.128.156	86.38.128.156	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
982	24:0b:2a:f1:c0:db	192.168.104.27	192.168.104.27	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
983	f4:8e:38:93:49:f9	192.168.144.25	192.168.144.25	Quan chung PKKQ	Windows 10 (Version 10.0, Build 10586, 64-bit Edition)	
984	50:9a:4c:32:23:95	192.168.144.57	192.168.144.57	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
985	60:cf:84:6a:7b:8a	86.38.128.25	86.38.128.25	Học viện Phòng không - Không quân-Quan chung PKKQ	Windows 10 (Version 10.0, Build 22621, 64-bit Edition)	
986	f4:8e:38:94:e2:4c	192.168.144.59	192.168.144.59	Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
987	f4:8e:38:94:21:9c	192.168.144.58	192.168.144.58	Quan chung PKKQ	Windows 7 Service Pack 1 (Version 6.1, Build 7601, 32-bit Edition)	
988	f4:8e:38:90:2c:3d	192.168.144.61	192.168.144.61	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
989	50:9a:4c:32:25:b5	192.168.144.63	192.168.144.63	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
990	50:9a:4c:32:28:20	192.168.144.62	192.168.144.62	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
991	8c:ec:4b:88:24:3f	192.168.144.66	192.168.144.66	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
992	8c:ec:4b:88:22:17	192.168.144.65	192.168.144.65	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
993	50:9a:4c:32:26:b5	192.168.144.64	192.168.144.64	Quan chung PKKQ	Windows 10 (Version 10.0, Build 17763, 64-bit Edition)	
994	50:9a:4c:13:76:74	192.168.144.67	192.168.144.67	Quan chung PKKQ	Windows 10 (Version 10.0, Build 18362, 64-bit Edition)	
995	50:e5:49:1c:18:23	192.168.201.72	192.168.201.72	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 19041, 64-bit Edition)	
996	74:d4:35:6f:c8:e2	192.168.201.73	192.168.201.73	Ban CNTT-Bộ Tham mưu-Quan chung PKKQ	Windows 10 (Version 10.0, Build 10240, 64-bit Edition)	
\.


--
-- Data for Name: ip_ranges; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ip_ranges (id, parent_unit_name, unit_name, ip_range, last_scanned_at) FROM stdin;
1	test2	test2	10.10.60.0/24	\N
\.


--
-- Data for Name: scan_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scan_profile (id, name, description, bot_kind, args, is_active, created_at) FROM stdin;
2	Simple Scan	Liveness IP	basic	-sT -p 80,443 -T4	t	2025-08-31 08:23:05.678694+00
1	KeyPing	Simple scan	basic	-sT -p 22,80,443,3389 --max-retries 1	f	2025-08-29 08:07:46.449469+00
\.


--
-- Data for Name: scan_results; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scan_results (id, ip_range_id, ip, port, status_port, first_detect, last_scan, os, detail_port) FROM stdin;
516700	1	10.10.60.79	3389	open	2025-08-28 02:40:50.452055	2025-08-28 02:40:50.452078	{}	{}
516702	1	10.10.60.10	3389	open	2025-08-28 02:39:02.133347	2025-08-28 02:39:02.133419	{}	{}
516703	1	10.10.60.79	22	open	2025-08-28 02:40:50.451993	2025-08-28 02:40:50.452025	{}	{}
516701	1	10.10.60.13	443	open	2025-08-28 02:39:06.769002	2025-08-31 15:29:25.727731	{}	{}
\.


--
-- Name: fms_ip_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fms_ip_id_seq', 996, true);


--
-- Name: ip_ranges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ip_ranges_id_seq', 6788, true);


--
-- Name: scan_profile_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scan_profile_id_seq', 2, true);


--
-- Name: scan_results_update_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scan_results_update_id_seq', 516703, true);


--
-- Name: fms_ip fms_ip_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fms_ip
    ADD CONSTRAINT fms_ip_pkey PRIMARY KEY (id);


--
-- Name: ip_ranges ip_ranges_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ip_ranges
    ADD CONSTRAINT ip_ranges_pkey PRIMARY KEY (id);


--
-- Name: scan_profile scan_profile_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_profile
    ADD CONSTRAINT scan_profile_name_key UNIQUE (name);


--
-- Name: scan_profile scan_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_profile
    ADD CONSTRAINT scan_profile_pkey PRIMARY KEY (id);


--
-- Name: scan_results scan_results_update_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_results
    ADD CONSTRAINT scan_results_update_pkey PRIMARY KEY (id);


--
-- Name: scan_results scan_results_update_ip_range_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.scan_results
    ADD CONSTRAINT scan_results_update_ip_range_id_fkey FOREIGN KEY (ip_range_id) REFERENCES public.ip_ranges(id);


--
-- PostgreSQL database dump complete
--

\unrestrict K7KJ47UaRlfJ0aUJPMDZ4FNYWGAyzrLvfmyJcIPnD5mX37b3d4juABhRmgdhISD

