CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE "public"."usuarios_admin" (
    "id_usuario" uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    "email" character varying(150) NOT NULL UNIQUE,
    "password_hash" character varying(255) NOT NULL,
    "nombre_completo" character varying(100) NOT NULL,
    "estado" boolean NOT NULL DEFAULT true,
    "creado_en" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);