within PVSystems.Electrical;
model CCM4 "Average CCM model with conduction losses and tranformer"
  extends Interfaces.SwitchNetworkInterface;
  parameter Modelica.SIunits.Resistance Ron=0 "Transistor on resistance";
  parameter Modelica.SIunits.Resistance RD=0 "Diode on resistance";
  parameter Real n(final unit="1") = 1
    "Transformer turns ratio 1:n (primary:secondary)";
equation
  v1 = i1*(Ron/d + (1 - d)*RD/n^2/d^2) + (1 - d)/d/n*v2;
  -i2 = i1*(1 - d)/d/n;
end CCM4;