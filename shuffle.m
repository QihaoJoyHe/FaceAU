function seq_test = shuffle(stimulinum,s,repetition)
if nargin < 2 
    seq_test = [];
end

rng(s); % make sure generate same random series
seq_test = randperm(stimulinum * repetition);

% adjust sequence number into the range of testing stimuli number
while length(find(seq_test > stimulinum)) > 0 % just in case the repetition > 2
    idx = find(seq_test > stimulinum);
    for n = 1:length(idx)
        seq_test(idx(n)) = seq_test(idx(n)) - stimulinum;
    end
end

% % check if there are two identical elements right next to each other, if so, change the last one with the previous 4th element
% rep_check_need = 1; 
% while rep_check_need == 1
%     n_reps = 0;
%     for n = 1: Testingstimulinum
%         rep_temp{n,1} = AngryHappyTestingData(seq_test(n)).name;
%         if n > 1
%             if strcmp(rep_temp{n,1}, rep_temp{n-1,1})
%                 n_reps = n_reps + 1;
%                 if n > 4
%                     temp = seq_test(n); % change
%                     seq_test(n) = seq_test(n-3);
%                     seq_test(n-3) = temp;
%                     clear temp
%                 else
%                     temp = seq_test(n); % change
%                     seq_test(n) = seq_test(n+3);
%                     seq_test(n+3) = temp;
%                     clear temp
%                 end
%             end
%         end
%     end
%     if n_reps == 0
%         rep_check_need = 0; % means no more check
%     end
end