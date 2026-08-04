-- AWGVA - Roles y usuarios de demostración para Oracle
-- Requisitos de esquema asumidos por el código actual:
-- ROL(ID_ROL, NOMBRE), DIVISION(ID_DIVISION, NOMBRE) y
-- USUARIO(CORREO, PASSWORD_HASH, NOMBRES, APELLIDO_PATERNO,
-- APELLIDO_MATERNO, ID_ROL_FK, ID_DIVISION_FK, ESTADO, CREADO_EN,
-- ACTUALIZADO_EN).

-- PBKDF2 ocupa 112 caracteres aproximadamente.
ALTER TABLE USUARIO MODIFY (PASSWORD_HASH VARCHAR2(255));

MERGE INTO ROL destino
USING (
    SELECT 'DOCENTE' NOMBRE FROM DUAL
    UNION ALL SELECT 'DIRECTOR' FROM DUAL
    UNION ALL SELECT 'ESTADIAS' FROM DUAL
    UNION ALL SELECT 'ADMIN' FROM DUAL
) origen
ON (UPPER(TRIM(destino.NOMBRE)) = origen.NOMBRE)
WHEN NOT MATCHED THEN
    INSERT (NOMBRE) VALUES (origen.NOMBRE);

MERGE INTO USUARIO destino
USING (
    SELECT datos.CORREO,
           datos.PASSWORD_HASH,
           datos.NOMBRES,
           datos.APELLIDO_PATERNO,
           datos.APELLIDO_MATERNO,
           rol.ID_ROL AS ID_ROL_FK,
           division.ID_DIVISION AS ID_DIVISION_FK
    FROM (
        SELECT 'docente.awgva@utez.edu.mx' CORREO,
               'pbkdf2$210000$717daeba2fc06ae6289db977ec35fffe$f31335bbc5c609a93b410e81d1a5e80ef886fbb6aa2f3143af8c1090dcb93e2c' PASSWORD_HASH,
               'Docente' NOMBRES, 'Prueba' APELLIDO_PATERNO, 'AWGVA' APELLIDO_MATERNO,
               'DOCENTE' NOMBRE_ROL, 'DATID' NOMBRE_DIVISION
        FROM DUAL
        UNION ALL
        SELECT 'director.awgva@utez.edu.mx',
               'pbkdf2$210000$7d0e9bb7b6b217c64534c91e5694162b$29aefb0e1af73936f9c37004f8733809ca786d581e4fb3e8f38a3acd648a6d83',
               'Director', 'Prueba', 'AWGVA', 'DIRECTOR', 'DATID'
        FROM DUAL
        UNION ALL
        SELECT 'estadias.awgva@utez.edu.mx',
               'pbkdf2$210000$22ee89bc3d12ba5d1f2e2df6db5f9fa0$298bc8880d05fbf4afb4f1ae2157d26899cbcd947a99a18b2b87139e30e08851',
               'Responsable', 'Estadias', 'AWGVA', 'ESTADIAS', NULL
        FROM DUAL
        UNION ALL
        SELECT 'admin.awgva@utez.edu.mx',
               'pbkdf2$210000$de0e933682dc42ddd8d6fd223f226508$393f34759e4d0b41544066fe61865778954c9a748c5a50f97f66db0ea3e825f5',
               'Administrador', 'General', 'AWGVA', 'ADMIN', NULL
        FROM DUAL
    ) datos
    JOIN ROL rol ON UPPER(TRIM(rol.NOMBRE)) = datos.NOMBRE_ROL
    LEFT JOIN DIVISION division
        ON UPPER(TRIM(division.NOMBRE)) = datos.NOMBRE_DIVISION
) origen
ON (LOWER(destino.CORREO) = LOWER(origen.CORREO))
WHEN MATCHED THEN UPDATE SET
    destino.PASSWORD_HASH = origen.PASSWORD_HASH,
    destino.NOMBRES = origen.NOMBRES,
    destino.APELLIDO_PATERNO = origen.APELLIDO_PATERNO,
    destino.APELLIDO_MATERNO = origen.APELLIDO_MATERNO,
    destino.ID_ROL_FK = origen.ID_ROL_FK,
    destino.ID_DIVISION_FK = origen.ID_DIVISION_FK,
    destino.ESTADO = 1,
    destino.ACTUALIZADO_EN = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN INSERT (
    CORREO, PASSWORD_HASH, NOMBRES, APELLIDO_PATERNO, APELLIDO_MATERNO,
    ID_ROL_FK, ID_DIVISION_FK, ESTADO, CREADO_EN
) VALUES (
    origen.CORREO, origen.PASSWORD_HASH, origen.NOMBRES,
    origen.APELLIDO_PATERNO, origen.APELLIDO_MATERNO,
    origen.ID_ROL_FK, origen.ID_DIVISION_FK, 1, CURRENT_TIMESTAMP
);

COMMIT;

-- Usuarios y contraseñas iniciales:
-- DOCENTE : docente.awgva@utez.edu.mx  / Docente#2026!
-- DIRECTOR: director.awgva@utez.edu.mx / Director#2026!
-- ESTADIAS: estadias.awgva@utez.edu.mx / Estadias#2026!
-- ADMIN   : admin.awgva@utez.edu.mx    / Admin#2026!
-- Cambia estas contraseñas después de la primera prueba.
