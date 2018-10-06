<p align="center">
  <h3 align="center">SimCSS</h3>

  <p align="center">
    Apply CSS stylesheets to Simulink models.
  </p>
</p>

SimCSS lets you style Simulink models using CSS stylesheets.

![logo](https://img.shields.io/badge/license-MIT-blue.svg)&nbsp;[![donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/gave92)

## Quick guide

Quick example to get started.

#### 1. Create a "styles.css" file with this content

```CSS
* {FontSize: 20}                                        /* I like big fonts all over the place */
From, Goto {BackgroundColor: "yellow"; ShowName: "off"} /* Applies to Goto and From blocks */
Constant {width: 70; Height: 40}                        /* Change Constant blocks size */
```

#### 2. Apply styles to current Simulink model
```matlab
applyCSS(bdroot,'styles.css')
```

© Copyright 2017 - 2018 by Marco Gavelli
