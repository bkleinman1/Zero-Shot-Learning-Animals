function [featuresTrain, featuresTest] = CNN()
    trainfile = textread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\trainclasses.txt', '%s');
    trainclasses = {};
    count = 1;
    for numTrainClasses = 1:length(trainfile)
        d = dir(fullfile("\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2/JPEGImages/", trainfile(numTrainClasses), "*.jpg"));
        d = d(1:100);
        for i = 1:length(d)
            s = struct2cell(d(numTrainClasses));
            trainclasses(count) = strcat(s(2), '\', s(1));
            count = count + 1;
        end
    end
    imdsTrain = imageDatastore(trainclasses,'IncludeSubfolders',true,'LabelSource','foldernames');

    testfile = textread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2/testclasses.txt', '%s');
    testclasses = {};
    count = 1;
    for numTestClasses = 1:length(testfile)
        d = dir(fullfile("\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2/JPEGImages/", testfile(numTestClasses), "*.jpg"));
        d = d(1:100);
        for i = 1:length(d)
            s = struct2cell(d(numTestClasses));
            testclasses(count) = strcat(s(2), '\', s(1));
            count = count + 1;
        end
    end
    imdsTest = imageDatastore(testclasses,'IncludeSubfolders',true,'LabelSource','foldernames');

    net = resnet18;

    inputSize = net.Layers(1).InputSize;

    augimdsTrain = augmentedImageDatastore(inputSize(1:2),imdsTrain);
    augimdsTest = augmentedImageDatastore(inputSize(1:2),imdsTest);

    layer = 'pool5';
    featuresTrain = activations(net,augimdsTrain,layer,'OutputAs','rows');
    featuresTest = activations(net,augimdsTest,layer,'OutputAs','rows');
end