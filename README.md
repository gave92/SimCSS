<p align="center">
  <a href="#">
    <img src="https://github.com/gave92/simcss/blob/master/docs/images/simcss-logo.png?raw=true" width="170" />
  </a>

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
* {FontSize: 20}                   /* I like big fonts all over the place */
.line, .annotation {FontSize: 20}  /* Applies to lines and annotations */

#TEST {ForegroundColor: 1 0 0}     /* Applies to blocks called "TEST" */

[name|=mass] {Orientation: "left"} /* Applies to "Mass", "Mass2", ... */

Subsystem Outport {BackgroundColor: "magenta";}         /* Applies to outports inside subsystems */

:commented {BackgroundColor: 0.3 0.3 0.3}               /* Applies to commented blocks */

Constant {width: 70; Height: 40}                        /* Change Constant blocks size */

From, Goto {BackgroundColor: "yellow"; ShowName: "off"} /* Applies to Goto and From blocks */
[GotoTag=A] {Commented: "on"}                           /* Comments Goto and From blocks with "GotoTag" = "A" */
```

#### 2. Apply styles to current Simulink model
```matlab
applyCSS(bdroot,'styles.css')
```

© Copyright 2017 - 2018 by Marco Gavelli
