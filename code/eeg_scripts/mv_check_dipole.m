tmp = [];
for k= 1:44
if any(ismember(flags.dipole{k},[1]))
   tmp = [tmp flags.dipoleRVabs{k}(1)];
end
end