function S = setfield_nested(S,field,value)
%SETFIELD_NESTED A wrapper on setfield that can handle nested subfields.
%The approach used here is originally from
%https://stackoverflow.com/questions/3753642/
%how-can-i-dynamically-access-a-field-of-a-field-of-a-structure-in-matlab
fields = textscan(field,'%s','Delimiter','.');
S = setfield(S,fields{1}{:},value);
end

