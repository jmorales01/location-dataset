-- ==============================================================================
-- Esquema de Base de Datos - Location Database
-- ==============================================================================
-- Este archivo define la estructura de las tablas necesarias para almacenar
-- la información geográfica usando el modelo de lista de adyacencia.
-- ==============================================================================

-- 1. Tabla de Países
-- Almacena los países soportados en la base de datos.
CREATE TABLE public.countries (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(255) NOT NULL,
    code       VARCHAR(3) NOT NULL, -- Código ISO del país (ej. PER, MEX)
    is_active  BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla de Niveles Administrativos
-- Define la jerarquía organizativa por país (ej. 1: Departamento, 2: Provincia).
CREATE TABLE public.administrative_levels (
    id          SERIAL PRIMARY KEY,
    country_id  INTEGER NOT NULL,
    name        VARCHAR(100) NOT NULL,
    level_order INTEGER NOT NULL -- Define el orden jerárquico (menor número = mayor jerarquía)
);

-- 3. Tabla de Ubicaciones (Lista de Adyacencia)
CREATE TABLE public.locations (
    id         SERIAL PRIMARY KEY,
    country_id INTEGER NOT NULL,
    parent_id  INTEGER, -- Apunta al id de la ubicación "padre". Es nulo para la región raíz.
    level_id   INTEGER NOT NULL,
    name       VARCHAR(150) NOT NULL,
    code       VARCHAR(20) -- Código interno geográfico (ej. UBIGEO en Perú)
);

-- Restricciones y Llaves Foráneas
ALTER TABLE ONLY public.administrative_levels 
    ADD CONSTRAINT fk_admin_country FOREIGN KEY (country_id) REFERENCES public.countries(id);

ALTER TABLE ONLY public.locations 
    ADD CONSTRAINT fk_loc_country FOREIGN KEY (country_id) REFERENCES public.countries(id);

ALTER TABLE ONLY public.locations 
    ADD CONSTRAINT fk_loc_parent FOREIGN KEY (parent_id) REFERENCES public.locations(id);

ALTER TABLE ONLY public.locations 
    ADD CONSTRAINT fk_loc_level FOREIGN KEY (level_id) REFERENCES public.administrative_levels(id);
