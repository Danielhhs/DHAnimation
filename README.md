# DHAnimation

DHAnimation is a framework based on OpenGL ES that implements many intersting animations for UIView.

There are four types of animations:

1. Transitions: Transitions are used for presenting view controller with custom animations. It shows the presented view controller form the presenting view controller with specific animations;
2. Built In Animations: Built In Animations are used for UIView appearance.
3. Built Out Animaitons: Built Out Animations are used for UIView disappearance.
4. Text Animations: Animations that are designed specifically for text.

How to use this framework:

1. Clone the repository;
2. Open "DHAnimation.xcodeproj";
3. Choose "DHAnimationFramework" scheme and build;
4. Choose "DHAnimationBundle" scheme and build;
5. Drag the generated "DHAnimationFramework.framework" and "DHAnimationFramework.bundle" to your own project;

How to use transition renderers:

1. import "DHConstants", "DHTransitionSettings";\n
2. Find the animation type, and call [DHConstants transitionRendererForName:transitionName];
3. Create transition settings by calling [DHTransitionSettings defaultSettingsForTransitionType:transitionType];
4. Configure the settings;
5. Call perform animation on renderer: [renderer performAnimationWithSettings:settings];

How to use animation renderers:

1. import "DHConstants", "DHObjectAnimationSettings";
2. Find the animation type, and call [DHConstants animationRendererForName:animationName];
3. Create animation settings by calling [DHObjectAnimationSettings defaultSettingsForAnimationType:animationType event:event forView:view];
4. Configure the settings;
5. Prepare for animation: [renderer prepareAnimationWithSettings:settings];
6. Start animation: [renderer startAnimation];

How to use text animation renderers:

1. import "DHConstants", "DHTextAnimationSettings";
2. Find the animation type, and call [DHConstants textRendererForType:animationType];
3. Create animation settings by calling [DHTextAnimationSettings defaultSettingForAnimationType:animationType];
4. Configure the settings;
5. Prepare for animation: [renderer prepareAnimationWithSettings:settings];
6. Start animation: [renderer startAnimation];
