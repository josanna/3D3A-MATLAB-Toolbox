function x = getInverseSTFT(Y, window, noverlap, nfft, padFlag)
%GETINVERSESTFT Inverse short-time Fourier transform (STFT).
%   X = GETINVERSESTFT(Y,WINDOW,NOVERLAP) returns X, the inverse STFT of a
%   spectrogram Y, which was computed using the specified WINDOW vector and
%   overlapping NOVERLAP samples.
%
%   X = GETINVERSESTFT(Y,WINDOW,NOVERLAP,NFFT) computes NFFT-length IFFTs
%   for each time frame. If unspecified, NFFT = LENGTH(WINDOW).
%
%   See also SPECTROGRAM, GETFORWARDSTFT.

%   =======================================================================
%   This file is part of the 3D3A MATLAB Toolbox.
%   
%   Contributing author(s), listed alphabetically by last name:
%   Joseph G. Tylka <josephgt@princeton.edu>
%   3D Audio and Applied Acoustics (3D3A) Laboratory
%   Princeton University, Princeton, New Jersey 08544, USA
%   
%   MIT License
%   
%   Copyright (c) 2018 Princeton University
%   
%   Permission is hereby granted, free of charge, to any person obtaining a
%   copy of this software and associated documentation files (the 
%   "Software"), to deal in the Software without restriction, including 
%   without limitation the rights to use, copy, modify, merge, publish, 
%   distribute, sublicense, and/or sell copies of the Software, and to 
%   permit persons to whom the Software is furnished to do so, subject to 
%   the following conditions:
%   
%   The above copyright notice and this permission notice shall be included
%   in all copies or substantial portions of the Software.
%   
%   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
%   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
%   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
%   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
%   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
%   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
%   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
%   =======================================================================

winLen = length(window);
if nargin < 4 || isempty(nfft)
    nfft = winLen;
end
if nargin < 5 || isempty(padFlag)
    padFlag = false;
end

hopLen = winLen - noverlap;
numPartitions = size(Y,2);
xPadLen = STFT_part2len(numPartitions, winLen, noverlap, false); % return padded length
xMat = ifft(Y,nfft,1,'symmetric');

x = zeros(xPadLen,1);
winSum = zeros(xPadLen,1);
for ii = 1:numPartitions
    indx = (1:winLen) + (ii-1)*hopLen;
    x(indx) = x(indx) + window.*xMat(1:winLen,ii);
    winSum(indx) = winSum(indx) + window.^2;
end
x = x ./ winSum;
if padFlag
    x = x((hopLen+1):(xPadLen-noverlap));
end

end