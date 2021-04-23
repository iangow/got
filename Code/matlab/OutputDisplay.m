% OutputDisplay routine:
%
% This routine is used in the simulations described in Section 4.0 of 
% Gow, Ormazabal and Taylor.This routine takes the OUT matrix produced 
% by the Output routine and saves it into a CSV text file. 

fid = fopen('GOT_simsA.csv', 'wt');
fprintf(fid, text1);

form_str = '';
for j = 1:size(out,2)
  form_str = strcat(form_str, ' %6.6f ,');
end
form_str =strcat(form_str, ' \n');

for i = 1:size(out,1)
  fprintf(fid, form_str, real(out(i,:)));
end
fclose(fid);
