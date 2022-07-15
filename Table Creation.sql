
CREATE TABLE IF NOT EXISTS public.card_holder
(
    id integer NOT NULL,
    name character(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT card_holder_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.card_holder
    OWNER to postgres;
    -- Table: public.credit_card

-- DROP TABLE IF EXISTS public.credit_card;

CREATE TABLE IF NOT EXISTS public.credit_card
(
    card character varying(20) COLLATE pg_catalog."default" NOT NULL,
    cardholder_id integer NOT NULL,
    CONSTRAINT credit_card_pkey PRIMARY KEY (card),
    CONSTRAINT "cardholder_FK" FOREIGN KEY (cardholder_id)
        REFERENCES public.card_holder (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.credit_card
    OWNER to postgres;


    -- Table: public.merchant_category

-- DROP TABLE IF EXISTS public.merchant_category;

CREATE TABLE IF NOT EXISTS public.merchant_category
(
    id integer NOT NULL,
    name character varying(20) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT merchant_category_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.merchant_category
    OWNER to postgres;

---- Table: public.merchant
DROP TABLE IF EXISTS public.merchant
-- ;

CREATE TABLE IF NOT EXISTS public.merchant
(
    id integer NOT NULL,
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    id_merchant_category integer NOT NULL,
    CONSTRAINT merchant_pkey PRIMARY KEY (id),
    CONSTRAINT "merchant_category_FK" FOREIGN KEY (id_merchant_category)
        REFERENCES public.merchant_category (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.merchant
    OWNER to postgres;

-- Table: public.transaction

DROP TABLE IF EXISTS public.transaction;

CREATE TABLE IF NOT EXISTS public.transaction
(
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    amount money NOT NULL,
    card character varying(20) COLLATE pg_catalog."default" NOT NULL,
    id_merchant integer NOT NULL,
    CONSTRAINT transaction_pkey PRIMARY KEY (id),
    CONSTRAINT "merchant_FK" FOREIGN KEY (id_merchant)
        REFERENCES public.merchant (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.transaction
    OWNER to postgres;