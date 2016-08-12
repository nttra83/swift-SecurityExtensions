import Quick
import Nimble

class SecKey_CryptTests: QuickSpec {
    override func spec() {
        it("can decrypt encrypted utf8 strings") {
            expect { Void->Void in
                let (privKey, pubKey) = try SecKey.generateKeyPair(ofSize: 512)
                let text = "This is some text"
                let encrypted = pubKey.encrypt(text)
                let decrypted = privKey.decryptUtf8(encrypted!)
                expect(decrypted) == text
            }.toNot(throwError())
        }

        it("can decrypt encrypted data") {
            expect { Void->Void in
                let (privKey, pubKey) = try SecKey.generateKeyPair(ofSize: 512)
                let data: [UInt8] = [1, 42, 255, 128, 33, 183]
                let encrypted = pubKey.encrypt(data)
                let decrypted = privKey.decrypt(encrypted!)
                expect(decrypted) == data
            }.toNot(throwError())
        }

        it("cannot decrypt rubbish") {
            expect { Void->Void in
                let (privKey, _) = try SecKey.generateKeyPair(ofSize: 512)
                expect(privKey.decrypt([1,2,3])).to(beNil())
            }.toNot(throwError())
        }

        it("cannot encrypt with private key") {
            expect { Void->Void in
                let (privKey, _) = try SecKey.generateKeyPair(ofSize: 512)
                expect(privKey.encrypt([1,2,3])).to(beNil())
            }.toNot(throwError())
        }

        fit("can encrypt a long string") {
            expect { Void->Void in
                let (privKey, pubKey) = try SecKey.generateKeyPair(ofSize: 512)
                let loremIpsumBytes = [UInt8](loremIpsum.utf8)
                let encryptedBytes = pubKey.encrypt(loremIpsumBytes)
                expect(encryptedBytes).toNot(beNil())
                let decryptedBytes = privKey.decrypt(encryptedBytes!)
                expect(decryptedBytes).toNot(beNil())
                expect(decryptedBytes) == loremIpsumBytes
            }.toNot(throwError())
        }
    }
}

let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. " +
        "Donec vulputate mauris id hendrerit suscipit. Aenean nisi magna, " +
        "lobortis quis tortor vitae, posuere tristique est. Sed id hendrerit " +
        "mi. Vivamus eget augue at velit convallis venenatis. Etiam quam purus, " +
        "accumsan venenatis quam eu, bibendum ornare nisl. Suspendisse non " +
        "sollicitudin lacus, et scelerisque libero. Nullam nec ullamcorper augue. " +
        "Fusce rhoncus massa in neque pharetra auctor. Duis tincidunt lectus a " +
        "congue auctor. Maecenas tincidunt magna at sem scelerisque rutrum. " +
        "Suspendisse turpis orci, imperdiet non commodo vel, placerat non " +
        "risus. Duis pellentesque dolor sed pretium placerat. Nulla tincidunt " +
        "diam quis leo sagittis, ac efficitur massa ornare. Pellentesque euismod " +
        "sem et fringilla semper. Aliquam semper, sem at consectetur congue, " +
        "ex justo vulputate ante, non facilisis orci sem sit amet lectus. Nunc " +
        "vitae ligula sit amet ante finibus pulvinar vitae nec nisi. Ut " +
        "vehicula sollicitudin mi, id mattis nunc egestas quis. Quisque " +
        "porttitor purus arcu, quis rutrum urna lacinia ac. Vivamus eu dui " +
        "id lectus tristique commodo et non urna. Duis sodales risus dui, ac " +
        "placerat est aliquet eu. Donec lobortis iaculis ligula ac rutrum. " +
        "Donec neque dui, venenatis non nibh accumsan, laoreet ultricies odio. " +
        "Suspendisse tincidunt tempor placerat. Pellentesque imperdiet sem " +
        "augue, nec accumsan elit cursus vel. Nullam pharetra erat nec sapien " +
        "dictum luctus. Nulla enim arcu, suscipit eu lectus congue, hendrerit " +
        "pulvinar erat. Etiam at hendrerit libero. Nam neque enim, suscipit vel " +
        "enim sed, hendrerit dignissim erat. Curabitur pellentesque, odio eget " +
        "faucibus facilisis, neque metus porta magna, sed euismod tortor dolor " +
        "in neque. Ut tristique massa tortor, in ornare mauris rhoncus non. " +
        "Curabitur mattis euismod turpis a rhoncus. Morbi id mollis erat. " +
        "Nullam at venenatis nulla, dapibus dignissim ex. Donec ut blandit " +
        "massa, at fermentum tortor. Morbi vitae lorem ac diam facilisis " +
        "commodo quis et nisi. Maecenas euismod convallis pharetra. Duis massa " +
        "nisi, elementum ut luctus id, cursus nec quam. Vestibulum vitae " +
        "iaculis metus. Suspendisse id consequat nunc. Donec gravida placerat " +
        "augue, sed varius nulla vehicula eget. Quisque gravida ornare lectus " +
        "et semper. Nunc non sem tincidunt, congue leo eget, maximus orci. Sed " +
        "malesuada rutrum quam. Mauris non nulla aliquam, vulputate sem ut, " +
        "facilisis ex. Aenean fringilla nec nisl nec lacinia. Vivamus ut mi " +
        "metus. Fusce sit amet mauris dui. Maecenas interdum suscipit nisl, " +
        "vestibulum bibendum nisi. Donec dignissim odio eget dictum viverra. " +
        "Sed tincidunt turpis augue, nec vulputate arcu pharetra ac. Interdum " +
        "et malesuada fames ac ante ipsum primis in faucibus. In ut nisl ac " +
        "mauris sodales cursus eget nec enim. Morbi cursus ac velit pretium " +
        "condimentum. Donec dapibus enim nec risus cursus, non vehicula velit " +
        "gravida. Ut nisi nisi, faucibus at blandit et, auctor non ex. Cras vitae " +
        "dolor erat. Aliquam sed ultrices nisi. Morbi tempus lobortis sapien nec " +
        "venenatis. Pellentesque ac nisl imperdiet, aliquet quam sed, venenatis nunc."
