# Location Database - Base de Datos Geográfica (Lista de Adyacencia)

Este repositorio contiene una base de datos de la división geográfica (UBIGEO) del Perú, estructurada utilizando el modelo de **lista de adyacencia** para representar jerarquías de manera eficiente y escalable.

Aunque el enfoque principal y los datos iniciales son de **Perú**, el diseño de la base de datos y la estructura del repositorio **soportan múltiples países y regiones**. ¡Cualquier contribución para añadir más países es totalmente bienvenida!

## 🌟 Características

- **Estructura Jerárquica Universal:** Utiliza un modelo de lista de adyacencia (relación `parent_id`) para relacionar países, estados/departamentos, condados/provincias y ciudades/distritos en una sola tabla o estructura unificada.
- **Soporte Multi-país:** Diseñado desde cero para escalar y almacenar datos de cualquier lugar del mundo manteniendo la consistencia relacional.
- **Fácil Integración:** Los datos pueden ser fácilmente exportados e importados a motores de bases de datos relacionales como PostgreSQL, MySQL, SQL Server, etc.

## 🗄️ Estructura de los Datos

La estructura se basa en el patrón de "Lista de Adyacencia", donde una entidad hace referencia a su elemento "padre". Un ejemplo conceptual del esquema de base de datos sería:

```sql
CREATE TABLE locations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    code VARCHAR(50), -- Código postal o código UBIGEO
    parent_id INTEGER REFERENCES locations(id),
    type VARCHAR(50) NOT NULL -- Ej: 'COUNTRY', 'STATE', 'PROVINCE', 'CITY'
);
```

### Organización del Repositorio

Para facilitar las contribuciones, el código SQL se ha dividido en dos archivos principales dentro de la carpeta `postgres`:

1. `postgres/schema.sql`: Contiene la estructura de la base de datos (tablas y llaves foráneas) documentada con comentarios explicando cada tabla y campo clave.
2. `postgres/data.sql`: Contiene únicamente las sentencias `INSERT` con la información geográfica, documentada también para saber el orden de inserción.

### ¿Cómo funciona la jerarquía?
- **Nivel 1 (País):** Es el nodo raíz. Su `parent_id` es nulo (`NULL`).
- **Nivel 2 (Región/Estado/Departamento):** Su `parent_id` apunta al ID del País.
- **Nivel 3 (Provincia/Condado):** Su `parent_id` apunta al ID de la Región.
- **Nivel 4 (Distrito/Ciudad):** Su `parent_id` apunta al ID de la Provincia.

## 🤝 ¿Cómo contribuir?

¡Las contribuciones son el corazón de este proyecto! Si deseas agregar la base de datos geográfica de tu país o corregir/actualizar datos existentes, sigue estos pasos:

1. Haz un **Fork** de este repositorio.
2. Crea una rama para tu país o mejora (`git checkout -b feature/agregar-datos-mexico`).
3. Agrega la información en el archivo `postgres/data.sql`. Asegúrate de respetar el siguiente orden para mantener la integridad referencial de la lista de adyacencia:
   - Inserta el país en la tabla `countries` (al final del bloque de países).
   - Inserta los niveles administrativos del país en `administrative_levels`.
   - Inserta todos los registros geográficos en la tabla `locations` utilizando los IDs correspondientes (asegúrate de que los IDs no colisionen con los de otros países).
4. Haz **Commit** de tus cambios (`git commit -m 'feat: agrega base de datos geográfica de México'`).
5. Haz **Push** a tu rama (`git push origin feature/agregar-datos-mexico`).
6. Abre un **Pull Request** detallando los cambios y agregando enlaces a las fuentes.

*Nota: Por favor, indica la fuente oficial (ej. página gubernamental o instituto de estadística) de donde obtuviste los datos para garantizar su precisión y fiabilidad en la base de datos comunitaria.*

## 📄 Licencia

Este proyecto es de código abierto. Siéntete libre de utilizar, modificar y distribuir estos datos en tus propios proyectos, ya sean personales o comerciales.
