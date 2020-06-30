function probs = compute_attribute_probs(models, testHist)
% 
    for i = 1:length(models) %loop through 85 models
        for j = 1:size(testHist, 1) %loop through each histogram for test images
            [label, scores] = predict(models{i}, testHist(j,:));
            probs(i, j) = scores(2);
        end
    end

end