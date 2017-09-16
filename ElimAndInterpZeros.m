function [massOut] = ElimAndInterpZeros(massIn)
%FUNCTION_NAME - Interpolate data points that read as zero in mass data
%
% Syntax:  [massOut] = ElimAndInterpZeros(massIn)
%
% Inputs:
%    massIn - Input mass data with zeros
%
% Outputs:
%    massOut - Output mass data where zeros have been removed and
%    interpolated over
%
% Example: 
%    Line 1 of example
%    Line 2 of example
%    Line 3 of example
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2

% Author: Dr. Craig N Dolder
% Universiy of Southampton
% email: C.N.Dolder@soton.ac.uk
% Website: https://github.com/DapperVibes
% Sep 2017; Last revision: 16-Sep-2017

%------------- BEGIN CODE --------------

massOut = massIn;

% Set all 0 values to NaN
massOut(massIn<200) = NaN;

% Find the indicies of all NaN values
ni = isnan(massOut);
% Indicies of values that are non NaN
ri = find(~ni);
% Interpolate over NaN values
massOut(ni)=interp1(ri,massOut(ri),find(ni),'linear','extrap');

% i = 1;
% if isnan(massOut(1));
%     while isnan(massOut(i));
%         i=i+1;
%     end



% %% Condition data
% From = 2641;
% 
% % Remove masses below a nominal value
% m1 = 30;
% d1 = 50;
% MassSeries = TDMS.Membranes.Mass_1__g_.data(From:end).';
% DistSeries = TDMS.Membranes.Distance_1__mm_.data(From:end).';
% TimeSeries = TDMS.Membranes.Time.data(From:end).';
% PumpOn1 = TDMS.Membranes.Pump_1__1_0_.data(From:end).';
% PumpOn2 = TDMS.Membranes.Pump_2__1_0_.data(From:end).';
% tHours = TimeSeries/3600;
% MassSeries(MassSeries<m1) = NaN;
% DistSeries(DistSeries<d1) = NaN;
% MassSeries([0; abs(diff(MassSeries))]>96) = NaN;

% % Interpolate NaN sections
% ni = isnan(MassSeries);
% ri = find(~ni);
% nid = isnan(DistSeries);
% rid = find(~nid);
% 
% % Eliminate leading and trailing NaNs
% MassSeries(ni([1:(min(ri)-1) (max(ri)+1):end]))=0;
% MassSeries(ni)=interp1(ri,MassSeries(ri),find(ni));
% DistSeries(nid)=interp1(rid,DistSeries(rid),find(nid));
% 
% % Eliminate segments when pump is on
% 
% logicp = PumpOn1==1;
% logicp = [false; logicp(1:(end-1))];
% 
% % Ens of Pump sections
% ni2 = PumpOn1(1:(end-1))-PumpOn1(2:end);
% ri2a = find(ni2==-1);
% ri2b = find(ni2==1)+2;
% ri2a(~isnan(DistSeries(ri2a-NumBefore))) = [];
% ri2b(~isnan(DistSeries(ri2b+NumAfter+1))) = [];
% N = length(PumpOn1);
% NumBefore = 1;
% NumAfter = 1;
% for icount = ri2a.'
%     if icount>NumBefore
%         MassSeries((icount-NumBefore+1):(icount+1)) = NaN;
%         DistSeries((icount-NumBefore+1):(icount+1)) = NaN;
%     end
% end
% ri2b(ri2b>(N-NumAfter)) = [];
% for icount = ri2b.'
%     if icount<(N-NumAfter)
%         MassSeries((icount):(icount+NumAfter)) = NaN;
%         DistSeries((icount):(icount+NumAfter)) = NaN;
%     end
% end
% 
% MassSeries(logical(logicp)) = NaN;
% DistSeries(logical(logicp)) = NaN;

%------------- END OF CODE --------------

