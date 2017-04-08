within PVSystems.Control;
block SignalPWM "Generates a pulse width modulated (PWM) boolean fire signal"
  extends Modelica.Blocks.Icons.Block;
  parameter Real dMax=1 "Maximum duty cycle";
  parameter Real dMin=0 "Minimum duty cycle";
  parameter Modelica.SIunits.Frequency fs "Switching frequency";
  parameter Modelica.SIunits.Time startTime=0 "Start time";
  parameter Boolean provideComplement=false
    "Provide fire signal and complement";
  parameter Real deadTime=0 "Firing signals dead time"
    annotation (Dialog(enable=provideComplement));
  Modelica.Blocks.Interfaces.RealInput vc "Control voltage"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.BooleanOutput c1 "Firing PWM signal" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Modelica.Blocks.Interfaces.BooleanOutput c2 if provideComplement
    "Firing PWM signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=dMax, uMin=dMin)
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Modelica.Blocks.Logical.Less greaterEqual annotation (Placement(
        transformation(extent={{-10,10},{10,-10}}, origin={0,0})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(final startTime=
        startTime, final samplePeriod=1/fs)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Modelica.Blocks.Sources.SawTooth sawtooth(
    final period=1/fs,
    final amplitude=1,
    final nperiod=-1,
    final offset=0,
    final startTime=startTime) annotation (Placement(transformation(origin={-50,
            -50}, extent={{-10,-10},{10,10}})));
  Modelica.Blocks.MathBoolean.OnDelay c1_onDelay(delayTime=if provideComplement
         then deadTime else 0)
    annotation (Placement(transformation(extent={{76,-4},{84,4}})));
  Modelica.Blocks.MathBoolean.OnDelay c2_onDelay(delayTime=deadTime)
    annotation (Placement(transformation(extent={{76,-84},{84,-76}})));
  Modelica.Blocks.Logical.Not notBlock
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
equation
  connect(vc, limiter.u)
    annotation (Line(points={{-120,0},{-92,0}}, color={0,0,127}));
  connect(limiter.y, zeroOrderHold.u)
    annotation (Line(points={{-69,0},{-69,0},{-62,0}}, color={0,0,127}));
  connect(sawtooth.y, greaterEqual.u1) annotation (Line(points={{-39,-50},{-20,
          -50},{-20,0},{-12,0}}, color={0,0,127}));
  connect(zeroOrderHold.y, greaterEqual.u2) annotation (Line(points={{-39,0},{-39,
          0},{-30,0},{-30,8},{-12,8}}, color={0,0,127}));
  connect(c1_onDelay.y, c1)
    annotation (Line(points={{84.8,0},{110,0}}, color={255,0,255}));
  connect(c1_onDelay.u, greaterEqual.y)
    annotation (Line(points={{74.4,0},{11,0}}, color={255,0,255}));
  connect(c2_onDelay.y, c2)
    annotation (Line(points={{84.8,-80},{110,-80}}, color={255,0,255}));
  connect(notBlock.y, c2_onDelay.u)
    annotation (Line(points={{61,-80},{74.4,-80}}, color={255,0,255}));
  connect(notBlock.u, greaterEqual.y) annotation (Line(points={{38,-80},{20,-80},
          {20,0},{11,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),graphics={
        Line(points={{-100,0},{-98,0},{12,0}}, color={0,0,255}),
        Line(points={{-60,-22},{-60,-64},{44,-64},{44,-36}}, color={0,0,255}),
        Line(points={{-80,-16},{-80,-20},{-40,20},{-40,-20},{-36,-16}}, color={
              0,0,255}),
        Line(points={{-62,0},{-76,4},{-76,-4},{-62,0}}, color={0,0,255}),
        Line(points={{44,-36},{44,-36},{40,-50},{44,-50},{48,-50},{44,-36}},
            color={0,0,255}),
        Line(points={{20,-20},{22,-20},{24,-20},{24,20},{44,20},{44,-20},{64,-20},
              {64,-16}}, color={255,0,255}),
        Line(points={{-40,-16},{-40,-20},{0,20},{0,-20},{4,-16}}, color={0,0,
              255}),
        Line(points={{60,-20},{62,-20},{64,-20},{64,20},{84,20},{84,-20},{84,-20},
              {88,-20}}, color={255,0,255})}), Documentation(info="<html>
<p>
The signal input of the PWM controller is the duty cycle; the duty cycle is the ratio of the on time
to the switching period. The output firing signal is strictly determined by the actual duty cycle, indicated as <code>d</code> in Fig.&nbsp;1.
</p>

<table border=\"0\" cellspacing=\"0\" cellpadding=\"2\">
  <caption align=\"bottom\"><b>Fig. 1:</b> Firing (<code>fire</code>) and inverse firing (<code>notFire</code>) signal of PWM control; <code>d</code> = duty cycle; <code>f</code> = switching frequency </caption>
  <tr>
    <td>
      <img src=\"modelica://Modelica/Resources/Images/Electrical/PowerConverters/dutyCycle.png\">
    </td>
  </tr>
</table>

<p>
The firing signal is generated by comparing the sampled duty cycle input with a periodic saw tooth signal [<a href=\"modelica://Modelica.Electrical.PowerConverters.UsersGuide.References\">Williams2006</a>].
</p>
</html>"));

end SignalPWM;
