CREATE TABLE public.cobots (
    "id_cobot" varchar(32) NOT NULL,
    "nombre_cobot" varchar(64) NOT NULL,
    "ultima_actualizacion_catalogo" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id_cobot")
);

CREATE TABLE public.catalog_item (
	"id_item" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"nombre_item" VARCHAR(50) NOT NULL UNIQUE,
	"ingredientes" VARCHAR(200) NOT NULL,
	"imagen" VARCHAR NOT NULL,
	"codigo_modbus" INT NOT NULL UNIQUE CHECK (codigo_modbus > 0)
);

CREATE TABLE public.cobot_catalog (
	"id_cobot_catalog" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"id_item" INT REFERENCES catalog_item(id_item) NOT NULL,
	"id_cobot" VARCHAR(32) REFERENCES cobots(id_cobot) NOT NULL,
	"estado" BOOLEAN NOT NULL DEFAULT TRUE,
	"precio_item" NUMERIC NOT NULL CHECK (precio_item > 0), UNIQUE (id_cobot, id_item)
);

-- Insertar el registro principal del cobot
INSERT INTO cobots("id_cobot", "nombre_cobot")
VALUES ('CBT000T', 'Cobot JAKA');

