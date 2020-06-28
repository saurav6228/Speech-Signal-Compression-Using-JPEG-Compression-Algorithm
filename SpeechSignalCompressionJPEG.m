clc;
clear all;
close all;

filename = 'wavfile.wav';
% Reading the speech signal
[data, fs] = audioread(filename);
% Frame size is 64 because of need for 8x8 block matrix
f_size = 64;
% Frame duration
frame_duration = f_size/fs;
% No. of frames
n_f = floor(length(data)/f_size);

temp = 0;

for i = 1 : n_f 
    frames(i,:) = data(temp+1 : temp + f_size);
    temp = temp + f_size;
end 

Q50 = [ 16 11 10 16 24 40 51 61;
     12 12 14 19 26 58 60 55;
     14 13 16 24 40 57 69 56;
     14 17 22 29 51 87 80 62; 
     18 22 37 56 68 109 103 77;
     24 35 55 64 81 104 113 92;
     49 64 78 87 103 121 120 101;
     72 92 95 98 112 100 103 99];
 
 Q90 = [ 3 2 2 3 5 8 10 12;
         2 2 3 4 5 12 12 11;
         3 3 3 5 8 11 14 11;
         3 3 4 6 10 17 16 12;
         4 4 7 11 14 22 21 15;
         5 7 11 13 16 12 23 18;
         10 13 16 17 21 24 24 21;
         14 18 19 20 22 20 20 20];
          

% Selecting Qtable
Qtable = Q50;
 
temp = 0;
  
for i = 1 : n_f
    frame = frames(i,:);
    % 8x8 block matrix
    mat_8x8 = reshape(frame,8,8) .* 10000;
    % DCT matrix after applying Discrete cosine transform
    dct_mat = dct2(mat_8x8);
    % Quantized matrix after quantization with quantization table
    q_mat = round(dct_mat./Qtable);
    dq_mat = q_mat.*Qtable;
    % Reconstructed matrix after applying IDCT
    idct_mat = idct2(dq_mat);
    % Recovered Frame
    r_frame = reshape(idct_mat,1,64) ./10000;
    % Compressed speech signal
    compressed_sig(temp+1 : temp + f_size) = r_frame;
    r_frames(i,:) = r_frame;
    temp = temp + f_size;
end
compressed_sig = compressed_sig';

% Plotting graphs for different frames
no_of_frames = 5;
for i = 1:no_of_frames
    figure(i);
    hold on;
    plot(frames(i,:),'r');title('Speech Signal Compression using JPEG compression Algorithm');xlabel('Samples');ylabel('Amplitude');
    plot(r_frames(i,:),'--b');
    plot(frames(i,:) - r_frames(i,:),'g');
    legend('Original Speech Signal','Reconstructed Signal','Error Signal');
    hold off;
end



    
    
    