--
-- PostgreSQL database dump
--

-- Dumped from database version 12.13 (Debian 12.13-1.pgdg110+1)
-- Dumped by pg_dump version 12.13 (Debian 12.13-1.pgdg110+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
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
-- Name: clients; Type: TABLE; Schema: public; Owner: sa
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    lname text,
    country text,
    ord integer
);


ALTER TABLE public.clients OWNER TO sa;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: sa
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO sa;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sa
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: sa
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    name text,
    price integer
);


ALTER TABLE public.orders OWNER TO sa;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: sa
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.orders_id_seq OWNER TO sa;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: sa
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: sa
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: sa
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Data for Name: clients; Type: TABLE DATA; Schema: public; Owner: sa
--

COPY public.clients (id, lname, country, ord) FROM stdin;
4	Ронни Джеймс Дио	Russia	\N
5	Ritchie Blackmore	Russia	\N
1	Иванов Иван Иванович	USA	3
2	Петров Петр Петрович	Canada	4
3	Иоганн Себастьян Бах	Japan	5
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: sa
--

COPY public.orders (id, name, price) FROM stdin;
1	Шоколад	10
2	Принтер	3000
3	Книга	500
4	Монитор	7000
5	Гитара	4000
\.


--
-- Name: clients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sa
--

SELECT pg_catalog.setval('public.clients_id_seq', 5, true);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sa
--

SELECT pg_catalog.setval('public.orders_id_seq', 5, true);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: sa
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: sa
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: clients clients_ord_fkey; Type: FK CONSTRAINT; Schema: public; Owner: sa
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_ord_fkey FOREIGN KEY (ord) REFERENCES public.orders(id);


--
-- Name: TABLE clients; Type: ACL; Schema: public; Owner: sa
--

GRANT ALL ON TABLE public.clients TO "test-admin-user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.clients TO "test-simple-user";


--
-- Name: TABLE orders; Type: ACL; Schema: public; Owner: sa
--

GRANT ALL ON TABLE public.orders TO "test-admin-user";
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.orders TO "test-simple-user";


--
-- PostgreSQL database dump complete
--

