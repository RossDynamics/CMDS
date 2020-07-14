function value = getfield_nested(S,field)
%SETFIELD_NESTED A wrapper on getfield that can handle nested subfields.
%The approach used here is originally from
%https://stackoverflow.com/questions/3753642/
%how-can-i-dynamically-access-a-field-of-a-field-of-a-structure-in-matlab
fields = textscan(field,'%s','Delimiter','.');
value = getfield(S,fields{1}{:});
end

