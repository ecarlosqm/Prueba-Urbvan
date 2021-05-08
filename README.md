# Prueba técnica

## Estructura del proyecto

La aplicación se divide en modo jerárquico en tres módulos: Núcleo, Cliente e Interfaz de Usuario.

| Modulo | Descripción |
| ------ | ----------- |
| Núcleo   | Contiene la definición de entidades y servicios del dominio, así como su implementación. |
| Cliente | Contiene los controladores que se encargan de sincronizar los cambios de estado de la aplicación y comunicarse con el núcleo de la aplicación.|
| Interfaz de usuario    | Contiene los elementos relacionados a Flutter para exponer una interfaz grafica al usuario que le permita interactuar con el cliente.|\

Cada módulo conoce sólo a los módulos que se encuentran por encima de él en la jerarquía. Esto nos ayuda a modularizar el proyecto y garantizar que los elementos de mayor jerarquía sean los que dictan la evolución del proyecto y que no ocurra a la inversa.