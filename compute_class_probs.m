function probs = compute_class_probs(attributeProbs)
    [~, allClasses] = textread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\classes.txt', '%u %s');
    testclasses = textread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\testclasses.txt', '%s');
    predicate_matrix = dlmread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2/predicate-matrix-binary.txt');
    
    root = '\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\JPEGImages';
    
    nTestImages = 0;
    for ii = 1:numel(testclasses) %find how many test images there are
        T = dir(fullfile(root,testclasses{ii},'*.jpg'));
        files = {T(~[T.isdir]).name}; % files in subfolder.
        files = files(1:100); %only first 100 images to prevent overfitting
        nTestImages = nTestImages + length(files);
    end
    
    pred = [];
    count = 1;
    for i = 1:length(allClasses) %loops through classes
        for j = 1:length(testclasses) %loops through test classes
            if strcmp(allClasses(i),testclasses(j)) == 1
                pred(count,:) = predicate_matrix(i,:); %store the row of predicate matrix in pred
                count = count + 1;
            end
        end
    end


    for testImage = 1:nTestImages
        for i = 1:length(testclasses) %looping through all test classes
            PClass = [];
            for j = 1:length(pred(i,:)) %looping through each attribute in test predicate matrix
                if pred(i,j) == 0
                    PClass(j) = 1 - attributeProbs(j,testImage);
                else
                    PClass(j) = attributeProbs(j,testImage);
                end
            end
            product = 1;
            for z = 1:length(PClass)
                product = product * PClass(z);
            end
            probs(i, testImage) = product;
        end
    end
end