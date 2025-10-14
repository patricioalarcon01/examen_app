# Examen App — Flutter (Firebase Auth + CRUD REST)

Aplicación móvil desarrollada en Flutter que implementa:

- Login con Firebase Authentication.

- CRUD completo para Productos, Categorías y Proveedores consumiendo una API REST.

- Manejo de imágenes en la lista de productos.

- Manejo de errores, diálogos de confirmación y deshacer (UNDO) en eliminaciones.

Alumno: Patricio Alarcón M.-

Profesor: René Galarce G.- 

COMPUTACIÓN MÓVIL | eICFE1119-01

(Repositorio individual.)

## Funcionalidades

Autenticación: inicio y cierre de sesión con Firebase.

Productos:

- Listar, ver detalle, crear, editar (nombre, precio, imagen, estado), eliminar.

- Normalización de precio (entero si no tiene decimales) para compatibilidad con la API.

Categorías:

- Listar, ver, crear, editar (nombre, estado), eliminar.

Proveedores:

- Listar, ver, crear, editar (nombre, apellido, correo, estado), eliminar.

Adicional: encabezado Connection, close + reintento automático por intermitencias del servidor.

## Consumo de API

La app **consume la API REST entregada para la actividad** (HTTP con **Basic Auth**) para implementar los CRUD de **Productos**, **Categorías** y **Proveedores**.  


- Este repositorio es de uso académico. Si se publica, se puede adoptar una licencia abierta (p. ej., MIT).

