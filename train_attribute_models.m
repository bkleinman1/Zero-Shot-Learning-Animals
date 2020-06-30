function models = train_attribute_models(histograms, classes)
    models = cell(85, 1);
    [~, allClasses] = textread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\classes.txt', '%u %s');
    predicate_matrix = dlmread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2/predicate-matrix-binary.txt');
    
    pred = [];
    count = 1;
    for i = 1:length(allClasses) %loops through classes
        for j = 1:length(classes) %loops through train classes
            if strcmp(allClasses(i),classes(j)) == 1
                pred(count,:) = predicate_matrix(i,:); %store the row of predicate matrix in pred_train
                count = count + 1;
            end
        end
    end
    
    imagesInClass = 100;
    
    for feature = 1:length(pred)
        y = [];
        for class = 1:length(classes)
            for i = 1:imagesInClass
                y = [y; pred(class, feature)];
            end
        end
        disp(feature);
        models{feature} = fitcsvm(histograms, y, 'KernelFunction','rbf','Standardize',true);
        models{feature} = fitSVMPosterior(models{feature});
    end
    
end