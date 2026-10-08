--
-- PostgreSQL database dump
--

\restrict 8aF4YcoW9QdFzBQBHExNggkAMfKLHKwcosFjH6nmw34DS8KCLCvopBQCoAxwOaS

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    nom character varying(100) NOT NULL,
    description text
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: commande_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commande_details (
    id integer NOT NULL,
    commande_id integer,
    produit_id integer,
    quantite integer DEFAULT 1 NOT NULL,
    prix_unitaire numeric(10,2) NOT NULL
);


--
-- Name: commande_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commande_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commande_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commande_details_id_seq OWNED BY public.commande_details.id;


--
-- Name: commandes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.commandes (
    id integer NOT NULL,
    table_id integer,
    date_commande timestamp without time zone DEFAULT now(),
    statut character varying(20) DEFAULT 'en attente'::character varying
);


--
-- Name: commandes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commandes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commandes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commandes_id_seq OWNED BY public.commandes.id;


--
-- Name: produits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.produits (
    id integer NOT NULL,
    nom character varying(150) NOT NULL,
    description text,
    prix numeric(10,2) NOT NULL,
    categorie_id integer,
    disponible boolean DEFAULT true
);


--
-- Name: produits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.produits_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: produits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.produits_id_seq OWNED BY public.produits.id;


--
-- Name: tables_restaurant; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tables_restaurant (
    id integer NOT NULL,
    numero integer NOT NULL,
    capacite integer NOT NULL,
    statut character varying(20) DEFAULT 'libre'::character varying
);


--
-- Name: tables_restaurant_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tables_restaurant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tables_restaurant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tables_restaurant_id_seq OWNED BY public.tables_restaurant.id;


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: commande_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commande_details ALTER COLUMN id SET DEFAULT nextval('public.commande_details_id_seq'::regclass);


--
-- Name: commandes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commandes ALTER COLUMN id SET DEFAULT nextval('public.commandes_id_seq'::regclass);


--
-- Name: produits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produits ALTER COLUMN id SET DEFAULT nextval('public.produits_id_seq'::regclass);


--
-- Name: tables_restaurant id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_restaurant ALTER COLUMN id SET DEFAULT nextval('public.tables_restaurant_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.categories VALUES (1, 'Boissons', 'Cafés, thés, jus et sodas');
INSERT INTO public.categories VALUES (2, 'Plats', 'Plats principaux salés');
INSERT INTO public.categories VALUES (3, 'Desserts', 'Pâtisseries et douceurs');


--
-- Data for Name: commande_details; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.commande_details VALUES (1, 1, 1, 2, 2.50);


--
-- Data for Name: commandes; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.commandes VALUES (1, 1, '2026-09-16 12:50:37.095836', 'servie');


--
-- Data for Name: produits; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.produits VALUES (1, 'Café expresso', 'Café italien classique', 2.50, 1, true);
INSERT INTO public.produits VALUES (2, 'Thé à la menthe', 'Thé vert traditionnel', 3.00, 1, true);
INSERT INTO public.produits VALUES (3, 'Pizza Margherita', 'Tomate, mozzarella, basilic', 12.00, 2, true);
INSERT INTO public.produits VALUES (4, 'Panini poulet', 'Poulet grillé, crudités', 8.50, 2, true);
INSERT INTO public.produits VALUES (5, 'Tiramisu', 'Dessert italien au café', 6.00, 3, true);


--
-- Data for Name: tables_restaurant; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.tables_restaurant VALUES (1, 1, 2, 'libre');
INSERT INTO public.tables_restaurant VALUES (2, 2, 4, 'libre');
INSERT INTO public.tables_restaurant VALUES (3, 3, 4, 'libre');
INSERT INTO public.tables_restaurant VALUES (4, 4, 6, 'libre');


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 3, true);


--
-- Name: commande_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.commande_details_id_seq', 1, true);


--
-- Name: commandes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.commandes_id_seq', 1, true);


--
-- Name: produits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.produits_id_seq', 5, true);


--
-- Name: tables_restaurant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tables_restaurant_id_seq', 4, true);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: commande_details commande_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commande_details
    ADD CONSTRAINT commande_details_pkey PRIMARY KEY (id);


--
-- Name: commandes commandes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_pkey PRIMARY KEY (id);


--
-- Name: produits produits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produits
    ADD CONSTRAINT produits_pkey PRIMARY KEY (id);


--
-- Name: tables_restaurant tables_restaurant_numero_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_restaurant
    ADD CONSTRAINT tables_restaurant_numero_key UNIQUE (numero);


--
-- Name: tables_restaurant tables_restaurant_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tables_restaurant
    ADD CONSTRAINT tables_restaurant_pkey PRIMARY KEY (id);


--
-- Name: commande_details commande_details_commande_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commande_details
    ADD CONSTRAINT commande_details_commande_id_fkey FOREIGN KEY (commande_id) REFERENCES public.commandes(id);


--
-- Name: commande_details commande_details_produit_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commande_details
    ADD CONSTRAINT commande_details_produit_id_fkey FOREIGN KEY (produit_id) REFERENCES public.produits(id);


--
-- Name: commandes commandes_table_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commandes
    ADD CONSTRAINT commandes_table_id_fkey FOREIGN KEY (table_id) REFERENCES public.tables_restaurant(id);


--
-- Name: produits produits_categorie_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.produits
    ADD CONSTRAINT produits_categorie_id_fkey FOREIGN KEY (categorie_id) REFERENCES public.categories(id);


--
-- PostgreSQL database dump complete
--

\unrestrict 8aF4YcoW9QdFzBQBHExNggkAMfKLHKwcosFjH6nmw34DS8KCLCvopBQCoAxwOaS

