CREATE OR REPLACE PROCEDURE create_item(
    p_nombre_item VARCHAR(50),
    p_ingredientes VARCHAR(200),
    p_imagen VARCHAR,
    p_codigo_modbus INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM catalog_item WHERE nombre_item = p_nombre_item) THEN
	    INSERT INTO Catalog_Item (nombre_item, ingredientes, imagen, codigo_modbus)
	    VALUES (p_nombre_item, p_ingredientes, p_imagen, p_codigo_modbus);
	ELSE
		RAISE EXCEPTION 'Item "%"already exists', p_nombre_item;
	END IF;
END;
$$;


CREATE OR REPLACE PROCEDURE add_item_to_cobot_catalog(
    p_id_cobot VARCHAR(32), 
    p_nombre_item VARCHAR(50),
    p_precio_item NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE 
    v_id_item INT;
BEGIN

    SELECT ci.id_item
    INTO v_id_item
    FROM Catalog_Item AS ci
    WHERE ci.nombre_item = p_nombre_item;
    

    IF v_id_item IS NOT NULL THEN
        IF NOT EXISTS (SELECT 1 FROM Cobot_Catalog WHERE id_item = v_id_item AND id_cobot = p_id_cobot) THEN
            INSERT INTO Cobot_Catalog (id_item, id_cobot, precio_item)
            VALUES (v_id_item, p_id_cobot, p_precio_item);
            
            UPDATE cobots
			SET ultima_actualizacion_catalogo = CURRENT_TIMESTAMP
			WHERE cobots.id_cobot = p_id_cobot;
        END IF;
    ELSE
        RAISE EXCEPTION 'El ítem con nombre "%" no existe en Catalog_Item', p_nombre_item;
    END IF;
END;
$$;


CREATE OR REPLACE PROCEDURE update_menu_item_state(p_item_state BOOLEAN, p_item_name VARCHAR, p_id_cobot VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_item INT;
BEGIN
    SELECT ci.id_item INTO v_id_item
    FROM catalog_item ci
    WHERE ci.nombre_item = p_item_name;

    IF v_id_item IS NULL THEN
        RAISE EXCEPTION 'El ítem "%" no existe en el catálogo maestro', p_item_name;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM cobot_catalog WHERE id_item = v_id_item AND id_cobot = p_id_cobot) THEN
        RAISE EXCEPTION 'El ítem "%" no está asignado al cobot %', p_item_name, p_id_cobot;
    END IF;

    UPDATE cobot_catalog
    SET estado = p_item_state
    WHERE id_item = v_id_item AND id_cobot = p_id_cobot;
	
    UPDATE cobots
    SET ultima_actualizacion_catalogo = CURRENT_TIMESTAMP
    WHERE id_cobot = p_id_cobot;
END;
$$;


CREATE OR REPLACE PROCEDURE update_menu_item_price(p_precio_item numeric(10,2), 
							p_item_name VARCHAR, p_id_cobot VARCHAR)
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_item INT;
BEGIN
    SELECT ci.id_item INTO v_id_item
    FROM catalog_item ci
    WHERE ci.nombre_item = p_item_name;

    IF v_id_item IS NULL THEN
        RAISE EXCEPTION 'El ítem "%" no existe en el catálogo maestro', p_item_name;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM cobot_catalog WHERE id_item = v_id_item AND id_cobot = p_id_cobot) THEN
        RAISE EXCEPTION 'El ítem "%" no está asignado al cobot %', p_item_name, p_id_cobot;
    END IF;

    UPDATE cobot_catalog
    SET precio_item = p_precio_item
    WHERE id_item = v_id_item AND id_cobot = p_id_cobot;

    UPDATE cobots
    SET ultima_actualizacion_catalogo = CURRENT_TIMESTAMP
    WHERE id_cobot = p_id_cobot;
END;
$$;