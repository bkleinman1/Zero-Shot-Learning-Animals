function accuracy = compute_accuracy(classProbs)
    root = '\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\JPEGImages';
    testclasses = textread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\testclasses.txt', '%s');
    actualClass = [];
    count = 1;
    for ii = 1:numel(testclasses) %work out actual class values for each image
        T = dir(fullfile(root,testclasses{ii},'*.jpg'));
        files = {T(~[T.isdir]).name}; % files in subfolder.
        for i = 1:length(files)
            actualClass(count) = ii;
            count = count + 1;
        end
    end

    correct = 0;
    wrong = 0;
    for i = 1:length(classProbs)
        [~, indx] = max(classProbs(:,i));
        if indx == actualClass(i)
            correct = correct + 1;
        else
            wrong = wrong + 1;
        end
    end
    
    accuracy = (correct/(correct+wrong))*100;
    disp(accuracy);
end