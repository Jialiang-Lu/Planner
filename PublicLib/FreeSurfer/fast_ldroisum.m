function [subjlist, roisum] = fast_ldroisum(roisumfile,trps)
% [subjlist, roisum] = fast_ldroisum(roisumfile,trps)
% reads in and sorts the text file created by roisummary-sess
% roisum is a structure.
%
% $Id: fast_ldroisum.m,v 1.1 2003/03/23 06:34:08 greve Exp $

subjlist = [];
roisum = [];

if(nargin ~= 1 & nargin ~= 2)
  fprintf('[subjlist, roisum] = fast_ldroisum(roisumfile,trps)\n');
  return;
end

fid = fopen(roisumfile,'r');
if(fid == -1)
  fprintf('ERROR: could not open %s\n',roisumfile);
  return;
end

alldata = [];
lineno = 0;
while(1)
  line = fgetl(fid);
  lineno = lineno + 1;
  if(isempty(line) | line == -1) break; end

  [tmp nitems] = sscanf(line,'%s',inf);
  if(lineno == 1)
    nitems0 = nitems;
  else
    if(nitems0 ~= nitems)
      fprintf('ERROR: line %d has wrong number of items (%d/%d)\n',...
	      nitems,nitems0);
      fprintf('%s\n',line);
    end
  end

  [subjname, data] = readline(line);
  subjlist = strvcat(subjlist,subjname);
  alldata = [alldata; data];  
end

roisum.nlabel   = alldata(:,1);
roisum.nactive  = alldata(:,2);
roisum.baseline = alldata(:,3);
roisum.stddev   = alldata(:,4);
roisum.DOF      = alldata(:,5);
roisum.TER      = alldata(1,6);
roisum.tPreStim = alldata(1,7);
roisum.Nc       = alldata(1,8);
roisum.Nh       = alldata(1,9);

for c = 1:roisum.Nc
  for h = 1:roisum.Nh
    n = (c-1)*roisum.Nh + h;
    roisum.est(:,c,h) = alldata(:,n+9);
  end
end

return;

%--------------------------------------------------------------------%
function [subjname, data] = readline(line);
subjname = [];
data = [];

subjname = sscanf(line,'%s',1);
fmt0 = '%*s';
while(1)
  fmt = sprintf('%s %%f',fmt0);
  [tmp n] = sscanf(line,fmt,1);
  if(n ~= 1) break; end
  data = [data tmp];
  fmt0 = sprintf('%s %%*f',fmt0);
end


return;