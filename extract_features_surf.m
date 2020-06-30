function hists = extract_features_surf(classes, K)
    root = '\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\JPEGImages';
    
    count = 1;
    features = [];
    featuresLength = [];
    for ii = 1:numel(classes)
        disp(classes(ii));
        T = dir(fullfile(root,classes{ii},'*.jpg'));
        files = {T(~[T.isdir]).name}; % files in subfolder.
        files = files(1:100); %only going through 100 files to prevent overfitting
        for jj = 1:numel(files)
            F = fullfile(root,classes{ii},files{jj}); % each file
            I = imread(F); % image
            I = rgb2gray(I); % gray image
            points = detectSURFFeatures(I);
            [imFeatures,validPoints] = extractFeatures(I,points, 'SURFsize', 128);
            features{count} = imFeatures;
            featuresLength(ii,jj) = size(imFeatures, 1);
            count = count + 1;
        end
    end

    features = cell2mat(features(:));

    disp('starting kmeans');

    [idx, C] = kmeans(features, K, 'Display', 'iter', 'MaxIter', 200);

    histograms = [];
    index = 1;
    for i = 1:numel(classes)
        T = dir(fullfile(root,classes{i},'*.jpg'));
        files = {T(~[T.isdir]).name}; % files in subfolder.
        files = files(1:100); %only going through 100 files to prevent overfitting
        for j = 1:numel(files)
            imageHist = hist(idx(index: index + featuresLength(i,j) - 1), K);
            imageHist = imageHist/sum(imageHist); %Normalise
            histograms{i,j} = imageHist;
            index = index + featuresLength(i,j);
        end
    end

    %Reshape the array to be numOfImages*1
    allHistograms = [];
    count = 1;
    for i = 1:size(histograms,2) %loop through columns
        for j = 1:size(histograms,1) %loop through rows
            if isempty(histograms{j,i}) == 0 %Large amount of cells were empty due to different number of images per class, checked if empty before reshaping
                allHistograms{count} = histograms{j,i};
                count = count + 1;
            end
        end
    end
    
    hists_expanded = allHistograms';
    hists_expanded = cell2mat(hists_expanded(:));
    
    hists = hists_expanded;
end