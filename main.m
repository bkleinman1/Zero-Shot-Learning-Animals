[featuresTrain, featuresTest] = CNN();

trainclasses = textread('\\smbhome.uscs.susx.ac.uk\bgk21\Documents\Animals_with_Attributes2\trainclasses.txt', '%s');

models = train_attribute_models(featuresTrain, trainclasses);

attribute_probs = compute_attribute_probs(models, featuresTest);

class_probs = compute_class_probs(attribute_probs);

accuracy = compute_accuracy(class_probs);

disp(accuracy);