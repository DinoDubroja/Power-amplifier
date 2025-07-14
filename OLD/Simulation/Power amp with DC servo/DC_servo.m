%% DC Servo Stability Analysis
% Analysis of stability using standard unity negative feedback conversion
% For audio amplifier DC offset cancellation (servo loop)

clear; close all; clc;

%% Section A - Define Parameters

% Amplifier parameters
A_amp = -2;                 % Audio amplifier DC gain (example)
fp_amp = 20;             % Amplifier dominant pole frequency (Hz)
w_amp = 2*pi*fp_amp;       % Amplifier dominant pole frequency (rad/s)

% Realistic integrator parameters
R_int = 10e3;              % Integrator input resistor (Ohms)
C_int = 1e-7;               % Integrator capacitor (Farads)
Rp_int = 10e5;              % Parallel resistor to limit DC gain (Ohms)

% Op-amp integrator gain: 1/(sRC), with DC-limiting resistor (Rp)

%% Section B - Transfer Function Definitions

s = tf('s');

% Amplifier transfer function (single pole amplifier)
G_amp = A_amp / (1 + s/w_amp);

% Integrator transfer function with parallel resistor Rp
G_int = - (Rp_int / (R_int * (1 + s*Rp_int*C_int)));

% Original open-loop transfer function (alpha path: G_amp, feedback beta: integrator)
G_open_original = G_amp * G_int;

% Non-unity feedback function beta = G_int
beta = G_int;

% Standard unity negative feedback conversion:
% G_new = G_alpha / (1 - G_alpha*(1 - beta))
G_new = G_amp / (1 - G_amp*(1 - beta));

%% Section C - Stability Analysis (Bode, Margin)

figure('Name','Bode Plot - Standardized Open-Loop');
margin(G_new);
grid on;
title('Bode Plot with Gain and Phase Margins (Unity Feedback Form)');

%% Section D - Pole-Zero Analysis

figure('Name','Pole-Zero Map');
pzmap(G_new);
grid on;
title('Pole-Zero Map of Standardized Open-Loop Transfer Function');

%% Section E - Step Response Analysis

figure('Name','Step Response Closed Loop');
T_closed = feedback(G_amp, beta);
step(T_closed);
grid on;
title('Step Response of Closed-Loop DC Servo Circuit');

%% Section F - Display Stability Margins Numerically

[GM, PM, Wcg, Wcp] = margin(G_new);

fprintf('Gain Margin: %.2f dB at %.2f Hz\n', 20*log10(GM), Wcg/(2*pi));
fprintf('Phase Margin: %.2f deg at %.2f Hz\n', PM, Wcp/(2*pi));
