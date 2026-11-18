CREATE OR REPLACE FUNCTION get_cobot_menu(p_id_cobot VARCHAR(32))
RETURNS TABLE (
    nombre_item VARCHAR(50),
    ingredientes VARCHAR(200),
    imagen VARCHAR,
    codigo_modbus INT,
    estado BOOLEAN,
    precio_item NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ci.nombre_item,
        ci.ingredientes,
        ci.imagen,
        ci.codigo_modbus,
        cc.estado,
        cc.precio_item
    FROM 
        Cobot_Catalog cc
    JOIN 
        Catalog_Item ci ON cc.id_item = ci.id_item
    WHERE 
        cc.id_cobot = p_id_cobot;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION check_catalog_update(p_id_cobot VARCHAR)
RETURNS TABLE(
    ultima_actualizacion_catalogo TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT c.ultima_actualizacion_catalogo
    FROM Cobots c
    WHERE c.id_cobot = p_id_cobot;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_all_items()
RETURNS TABLE(
    id_item INT,
    nombre_item VARCHAR(50),
    ingredientes VARCHAR(200),
    imagen VARCHAR,
    codigo_modbus INT
) AS $$
BEGIN 
    RETURN QUERY 
    SELECT ci.id_item, ci.nombre_item, ci.ingredientes, ci.imagen, ci.codigo_modbus 
    FROM Catalog_Item ci;
END
$$ LANGUAGE plpgsql;

