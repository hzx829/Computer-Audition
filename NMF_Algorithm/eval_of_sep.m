[source_sp,~] = audioread('speech_test.wav');
[source_noi,~] = audioread('noise_test.wav');
[estimate_sp,~] = audioread('speech_sep.wav');
[estimate_noi,~] = audioread('noise_sep.wav');

Esp_len = length(estimate_sp);
Enoi_len = length(estimate_noi);
source_sp = source_sp(1:Esp_len);
source_noi = source_noi(1:Enoi_len);

[SDR_sp,SIR_sp,SAR_sp,~] = bss_eval_sources(estimate_sp',source_sp');
[SDR_noi,SIR_noi,SAR_noi,~] = bss_eval_sources(estimate_noi',source_noi');