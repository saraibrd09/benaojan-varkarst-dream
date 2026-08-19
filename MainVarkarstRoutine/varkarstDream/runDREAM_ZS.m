%% 
% ----------------------------------------------------------------------------------------------%
%                                                                                               %
% DDDDDDDDDDD    RRRRRRRRRR     EEEEEEEEEE       AA       MMM         MMM    ZZZZZZZZ SSSSSSSSS %
% DDDDDDDDDDDD   RRRRRRRRRRR    EEEEEEEEEE       AA       MMM         MMM    ZZZZZZZZ SSSSSSSSS %
% DDD      DDD   RRR      RRR   EEE             AAAA      MMMM        MMM         ZZZ SSS       %
% DDD      DDD   RRR      RRR   EEE             AAAA      MMMMM      MMMM         ZZZ SSS       %
% DDD      DDD   RRR      RRR   EEE            AA  AA     MMMMM     MMMMM        ZZZ  SSS       %
% DDD      DDD   RRR      RRR   EEE            AA  AA     MMM MM   MM MMM        ZZZ  SSSS      %
% DDD      DDD   RRRRRRRRRRRR   EEEEEEEEEE    AA    AA    MMM  MMMMM  MMM --    ZZZ   SSSSSSSSS %
% DDD      DDD   RRRRRRRRRRRR   EEEEEEEEEE    AAAAAAAA    MMM   MMM   MMM --    ZZZ   SSSSSSSSS %
% DDD      DDD   RRR      RRR   EEE          AAA    AAA   MMM    M    MMM      ZZZ         SSSS %
% DDD      DDD   RRR      RRR   EEE          AAA    AAA   MMM         MMM      ZZZ          SSS %
% DDD      DDD   RRR      RRR   EEE         AAA      AAA  MMM         MMM     ZZZ           SSS %
% DDD      DDD   RRR      RRR   EEE         AAA      AAA  MMM         MMM     ZZZ           SSS %
% DDDDDDDDDDDD   RRR      RRR   EEEEEEEEEE  AAA      AAA  MMM         MMM    ZZZZZZZZZ SSSSSSSS %
% DDDDDDDDDDD    RRR      RRR   EEEEEEEEEE  AAA      AAA  MMM         MMM    ZZZZZZZZZ SSSSSSSS %
%                                                                                               %
% ----------------------------------------------------------------------------------------------%

% ---- DiffeRential Evolution Adaptive Metropolis algorithm with sampling from past states ---- %
%                                                                                               %
% DREAM runs multiple different chains simultaneously for global exploration, and automatically %
% tunes the scale and orientation of the proposal distribution using differential evolution.    %
% The algorithm maintains detailed balance and ergodicity and works well and efficient for a    %
% large range of problems, especially in the presence of high-dimensionality and                %
% multimodality. This version creates proposals from an archive of past states rather than      %
% the current position of the chains (as in DREAM)                                              %
%                                                                                               %
% DREAM_ZS developed by Jasper A. Vrugt and Cajo ter Braak                                      %
%                                                                                               %
% --------------------------------------------------------------------------------------------- %

% Clear memory and close pool of matlab nodes (cores)
clear all; close all hidden; clc; warning off

% Which folder
example_folder = 'example_1';

% Which file
example_file = strcat(example_folder,'.m');

% Go to main DREAM PACKAGE directory
addpath(pwd,[pwd '/postprocessing'],[pwd '/diagnostics'],[pwd '/gamesampling']);

% Run calibration
filerun = strcat(pwd,'\',example_folder,'\',example_file);
run(filerun)



