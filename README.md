# Prueba técnica

## Estructura del proyecto

En la carpeta ***core*** encontramos la lógica de negocio. En su interior vemos separado las clases que pertenecen al dominio, de las clases de implementación de servicios, en ***domain*** e ***infrastructure*** respectivamente. En la carpeta ***ui***, encontramos todo lo relacionado a la interfaz gráfica.

La aplicación está estructurada para separar la lógica de negocio de la interfaz de usuario e implementación de servicios.

## Probar la aplicación en local

### Establecer variables de configuración
Dentro de la carpeta config, haz una copia de config_sample.json y ponle como nombre dev_config.json. Dentro de este archivo coloca las marcadas.

### Configurar Mapas
Para configurar android reemplaza "YOUR KEY HERE" con tu API Key de google maps en el archivo AndroidManifest.xml.

<meta-data android:name="com.google.android.geo.API_KEY" android:value="YOUR KEY HERE"/>

Para configurar iOS reemplaza "YOUR KEY HERE" con tu API Key de google maps en el archivo AppDelegate.swift .

GMSServices.provideAPIKey("YOUR KEY HERE")

### Iniciar la aplicación

Ejecuta en terminal
```shell
flutter pub get
```

```shell
flutter run -t lib/main_dev.dart
```

## Tareas realizadas

Para completar la prueba, leí el documento y concluí que necesitaba implementar dos módulos, uno que me permitiera dar seguimiento a un objeto y otro que me permitiera generar rutas. Considere que estos módulos se deberían implementar de tal manera que se pudieran conectar a diferentes servicios.

Al modelar los módulos, lo más complejo de modelar fue la ruta. Para definir la ruta implementé una cola que solo me permitiera hacer modificaciones al último elemento o eliminar la ruta completa al eliminar la referencia al último nodo.

No pensé en usar un manejador de estados, porque flutter me pareció suficiente y la separación de la logia y la interfaz ya estaba lograda. De cualquier forma lo hice, con ayuda de la librería Flutter Bloc, para demostrar mis habilidades.

Para las variables de configuración use archivos json. Los archivos se colocan en la carpeta **config** y se leen al iniciar la aplicación. Se elige qué archivo usar de acuerdo a una variable. Por ejemplo, para la variable **dev** se elegiría el archivo **dev_config.json**.

Cuando estaba implementando el generador de rutas me pareció interesante presentarle las rutas alternativas al usuario e implemente la funcionalidad.
