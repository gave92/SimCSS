<p align="center">
  <a href="#">
    <img src="https://github.com/gave92/simcss/blob/master/docs/images/simcss-logo.png?raw=true" width="170" />
  </a>

  <h3 align="center">SimCSS</h3>

  <p align="center">
    Apply CSS stylesheets to Simulink models.
  </p>
</p>

With SimCSS, you can easily customize Simulink blocks through a simple CSS file.

![logo](https://img.shields.io/badge/license-MIT-blue.svg)&nbsp;[![donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.me/gave92)

#### What styles can be applied?

Any property of a Simulink block can be set with SimCSS. Everywhere you would normally use set_param(handle,'myproperty',myvalue), you could use the SimCSS equivalent {myproperty: myvalue}.

## SimCSS selectors

| Selector |  Example | Description |
:-------------------------:|:-------------------------:|:-------------------------:
\* |  | Apply style to all blocks
.class | .line (or .annotation) | Apply style to lines (or annotations)
#id | #TEST | Apply style to blocks named "TEST"
element | Constant | Apply style to Constant blocks
element1 element2 | Subsystem Outport | Apply style to outports inside subsystems
[Prop=Value] | [Tag=test] | Apply to blocks with a Tag equal to "test"

## Quick guide

Quick example to get started.

#### 1. Create a "styles.css" file with your styles

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
