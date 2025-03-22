var vsda_location = '/Applications/Visual Studio Code.app/Contents/Resources/app/node_modules/vsda/build/Release/vsda.node';
var a = require(vsda_location);
var signer = new a.signer();
process.argv.forEach(function (value, index, array) {
    if (index >= 2) {
        var r = signer.sign(value);
        console.log(r);
    }
});
