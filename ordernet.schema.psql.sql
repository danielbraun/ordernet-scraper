--
-- PostgreSQL database dump
--

-- Dumped from database version 11.4
-- Dumped by pg_dump version 11.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ordernet; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ordernet;


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: GetHoldings; Type: TABLE; Schema: ordernet; Owner: -
--

CREATE TABLE ordernet."GetHoldings" (
    _t character varying NOT NULL,
    _k character varying,
    a boolean NOT NULL,
    b numeric NOT NULL,
    c numeric NOT NULL,
    d numeric NOT NULL,
    e numeric NOT NULL,
    f numeric NOT NULL,
    g character varying NOT NULL,
    h boolean NOT NULL,
    i character varying NOT NULL,
    j character varying NOT NULL,
    k numeric NOT NULL,
    l numeric NOT NULL,
    m numeric NOT NULL,
    mm character varying,
    n numeric,
    o numeric NOT NULL,
    p numeric NOT NULL,
    q boolean NOT NULL,
    r numeric NOT NULL,
    s numeric NOT NULL,
    t numeric NOT NULL,
    u boolean NOT NULL,
    v numeric NOT NULL,
    w boolean NOT NULL,
    x boolean NOT NULL,
    y numeric NOT NULL,
    z numeric NOT NULL,
    ba numeric NOT NULL,
    bb numeric NOT NULL,
    bc numeric NOT NULL,
    bd numeric NOT NULL,
    be numeric NOT NULL,
    bf numeric NOT NULL,
    bg numeric NOT NULL,
    bh numeric NOT NULL,
    bi numeric NOT NULL,
    bj numeric NOT NULL,
    bk numeric NOT NULL,
    bl numeric NOT NULL,
    bm numeric NOT NULL,
    bn numeric NOT NULL,
    bo numeric NOT NULL,
    bp numeric NOT NULL,
    bq numeric NOT NULL,
    br numeric NOT NULL,
    bs boolean NOT NULL,
    bt numeric NOT NULL,
    bu numeric NOT NULL,
    bv numeric NOT NULL,
    bw numeric NOT NULL,
    bx numeric NOT NULL,
    by numeric NOT NULL,
    bz numeric NOT NULL,
    ca boolean NOT NULL,
    cb boolean NOT NULL,
    cc boolean NOT NULL,
    cd numeric NOT NULL,
    ce boolean NOT NULL,
    cg character varying NOT NULL
);


--
-- Name: portfolio_export; Type: VIEW; Schema: ordernet; Owner: -
--

CREATE VIEW ordernet.portfolio_export AS
 SELECT split_part(("GetHoldings".i)::text, ' '::text, 1) AS "Ticker",
    "GetHoldings".bd AS "Quantity",
    ("GetHoldings".bi / "GetHoldings".bd) AS "Cost Per Share"
   FROM ordernet."GetHoldings"
  WHERE (("GetHoldings".l = (12)::numeric) AND ("GetHoldings".m = (12)::numeric))
  ORDER BY (split_part(("GetHoldings".i)::text, ' '::text, 1));


--
-- PostgreSQL database dump complete
--

