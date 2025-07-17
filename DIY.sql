-- ========================================
-- CREATE DATABASE
-- ========================================
CREATE DATABASE DIY;
GO
USE DIY;
GO

-- ========================================
-- CREATE TABLES
-- ========================================

-- 1. Address
CREATE TABLE Address (
    id INT PRIMARY KEY IDENTITY(1,1),
    street VARCHAR(100),
    district VARCHAR(100),
    city VARCHAR(100)
);

-- 2. Users
CREATE TABLE [Users] (
    id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) UNIQUE NULL,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) DEFAULT 'user',
    status BIT DEFAULT 1,
    password VARCHAR(255) NULL,
);



CREATE TABLE User_Address (
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    PRIMARY KEY (user_id, address_id),
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (address_id) REFERENCES Address(id)
);


-- 3. Category
CREATE TABLE Category (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) UNIQUE NOT NULL
);

-- 4. Tag
CREATE TABLE Tag (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) UNIQUE NOT NULL
);

-- 5. Product
CREATE TABLE Product (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price FLOAT NOT NULL,
    status BIT DEFAULT 1,
    stockQuantity INT DEFAULT 0,
    category_id INT,
    image_url VARCHAR(255),
    FOREIGN KEY (category_id) REFERENCES Category(id)
);

-- 6. Product_Tag (n-n giữa Product và Tag)
CREATE TABLE Product_Tag (
    product_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (product_id, tag_id),
    FOREIGN KEY (product_id) REFERENCES Product(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- 7. Cart
CREATE TABLE Cart (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES [Users](id)
);

-- 8. Cart_Product (n-n)
CREATE TABLE Cart_Product (
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    PRIMARY KEY (cart_id, product_id),
    FOREIGN KEY (cart_id) REFERENCES Cart(id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);

-- 9. Orders
CREATE TABLE Orders (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    address_id INT NOT NULL,
    order_date DATETIME NOT NULL DEFAULT GETDATE(),
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Processing' CHECK(status IN ('Processing','Completed','Failed')),
    coupon_code VARCHAR(50),
    discount_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(id),
    FOREIGN KEY (address_id) REFERENCES Address(id)
);

-- 10. OrderItem
CREATE TABLE OrderItem (
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Product(id)
);

-- 11. Coupon
CREATE TABLE Coupon (
    code VARCHAR(50) PRIMARY KEY,
    description NVARCHAR(255),
    discount_value DECIMAL(10,2),
    is_percent BIT NOT NULL DEFAULT 0,
    min_order_value DECIMAL(10,2),
    quantity INT DEFAULT 1,
    expired_at DATETIME
);

ALTER TABLE Coupon
ADD max_usage_per_user INT DEFAULT 1;


-- Foreign key Coupon
ALTER TABLE Orders
ADD CONSTRAINT FK_Coupon FOREIGN KEY (coupon_code) REFERENCES Coupon(code);

CREATE TABLE User_Coupon (
    user_id INT NOT NULL,
    coupon_code VARCHAR(50) NOT NULL,
    used_at DATETIME NULL, -- cho phép null
    usage_count INT DEFAULT 0,
    PRIMARY KEY (user_id, coupon_code),
    FOREIGN KEY (user_id) REFERENCES [Users](id),
    FOREIGN KEY (coupon_code) REFERENCES Coupon(code)
);

CREATE TABLE spin_ticket (
    id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    ticket_number INT DEFAULT 0,
    play_date DATETIME NULL,
    CONSTRAINT FK_spin_ticket_user FOREIGN KEY (user_id) REFERENCES users(id)
);
ALTER TABLE spin_ticket
ADD flappy_play_date DATETIME NULL;




-- ========================================
-- INSERT SAMPLE DATA
-- ========================================

-- Address
INSERT INTO Address (street, district, city) VALUES
('123 DIY Street', 'District 1', 'Ho Chi Minh'),
('45 Handmade Lane', 'Tan Binh', 'Ho Chi Minh'),
('78 Creative Ave', 'Hai Chau', 'Da Nang');

-- Users
INSERT INTO [Users] (username, name, email, role, status, password) VALUES
('diylover01', 'Nguyen Van A', 'a@example.com', 'user', 1, 'hashedpass1'),
('craftqueen', 'Tran Thi B', 'b@example.com', 'admin', 1, 'hashedpass2'),
('makerzone', 'Le Van C', 'c@example.com', 'user', 1, 'hashedpass3');

INSERT INTO User_Address (user_id, address_id) VALUES (1, 1);
INSERT INTO User_Address (user_id, address_id) VALUES (2, 2);
INSERT INTO User_Address (user_id, address_id) VALUES (3, 3);


-- Category
INSERT INTO Category (name) VALUES
('flower'), ('animal'), ('toy'), ('gardening'), ('stationary'),
('nature'), ('space'), ('cartoon'), ('car'), ('bag'),
('pouche'), ('jewelry'), ('accessorie'), ('planter'), ('clothes');

-- Tag
INSERT INTO Tag (name) VALUES 
('cute'), ('modern'), ('minimalist'), ('vintage'), ('recycled'),
('education'), ('art'), ('furniture'), ('tech'), ('boho'), ('origami'),
('wood'), ('paper'), ('cardboard'), ('fabric'), ('yarn'), 
('metal'), ('clay'), ('led'), ('glass'), ('ribbon'), 
('paint'), ('foam'), ('electronic'),
('very-easy'), ('easy'), ('medium'), ('hard'), ('very-hard'),
('christmas'), ('halloween'), ('valentine'), ('birthday'), ('wedding'),
('easter'), ('new-year'), ('back-to-school'), ('summer'), ('spring'),
('autumn'), ('winter'), ('boy'), ('girl');

-- Product
INSERT INTO Product (name, description, price, status, stockQuantity, category_id, image_url) VALUES
('Paper Flower Bouquet', 'Beautiful handmade flowers using paper and ribbons.', 5.99, 1, 20, 1, 'images/Paper Flower Bouquet.jpg'),
('DIY Robot Toy', 'Assemble your own robot with electronic parts.', 15.50, 1, 10, 3, 'images/DIY Robot Toy.jpg'),
('Beaded Bracelet', 'Colorful bracelet made with recycled beads.', 3.75, 1, 0, 12, 'images/Beaded Bracelet.jpg'),
('Origami Crane', 'Traditional Japanese paper crane, symbol of peace and hope.', 1.25, 1, 50, 1, 'images/Origami Crane.jpg'),
('LED Bookmark', 'A simple bookmark with LED for night reading.', 4.99, 1, 15, 5, 'images/LED Bookmark.jpg'),
('DIY Clay Mini Pot', 'Create mini pots using colorful clay.', 3.50, 1, 25, 14, 'images/DIY Clay Mini Pot.jpg'),
('Recycled Bottle Vase', 'Turn old bottles into decorative vases.', 2.80, 1, 30, 6, 'images/Recycled Bottle Vase.jpg'),
('Cardboard Robot', 'Build a robot using cardboard and glue – fun and educational.', 6.75, 1, 18, 3, 'images/Cardboard Robot.jpg'),
('Mini Woven Basket', 'Hand-woven mini basket for desk organization.', 4.25, 1, 20, 11, 'images/Mini Woven Basket.jpg'),
('Bottle Cap Magnet', 'Cute magnets made from recycled bottle caps.', 1.80, 1, 40, 13, 'images/Bottle Cap Magnet.jpg'),
('Paper Lantern', 'Decorative paper lantern for parties.', 3.70, 1, 18, 1, 'images/Paper Lantern.jpg'),
('DIY Wooden Bookmark', 'Bookmark crafted from lightweight wood.', 2.30, 1, 27, 5, 'images/DIY Wooden Bookmark.jpg'),
('Felt Flower Brooch', 'Flower brooch made from colorful felt.', 2.90, 1, 33, 12, 'images/Felt Flower Brooch.jpg'),
('Mason Jar Vase', 'Repurpose mason jars as rustic vases.', 3.60, 1, 30, 6, 'images/Mason Jar Vase.jpg'),
('Yarn Wrapped Letters', 'Personalized letters wrapped with colorful yarn.', 5.40, 1, 13, 11, 'images/Yarn Wrapped Letters.jpg'),
('DIY Clay Fridge Magnet', 'Fun fridge magnet made with modeling clay.', 1.75, 1, 41, 13, 'images/DIY Clay Fridge Magnet.jpg'),
('Cardboard Cat House', 'Cardboard play house for cats.', 6.20, 1, 10, 4, 'images/Cardboard Cat House.jpg'),
('Painted Canvas Tote', 'Reusable canvas tote bag with hand-painted design.', 6.90, 1, 17, 10, 'images/Painted Canvas Tote.jpg'),
('Shell Wind Chime', 'Wind chime made from shells and string.', 4.80, 1, 12, 13, 'images/Shell Wind Chime.jpg'),
('DIY Dreamcatcher', 'Traditional dreamcatcher using yarn and beads.', 5.50, 1, 19, 11, 'images/DIY Dreamcatcher.jpg'),
('Origami Gift Box', 'Small origami box for gift wrapping.', 1.90, 1, 23, 1, 'images/Origami Gift Box.jpg'),
('Beaded Phone Charm', 'Trendy phone charm made from beads.', 2.60, 1, 18, 13, 'images/Beaded Phone Charm.jpg'),
('Knitted Cup Cozy', 'Keep your drinks warm with a knitted cozy.', 3.30, 1, 16, 15, 'images/Knitted Cup Cozy.jpg'),
('Foam Dinosaur Toy', 'Easy dinosaur toy using colored foam.', 2.80, 1, 25, 3, 'images/Foam Dinosaur Toy.jpg'),
('Cork Bulletin Board', 'DIY bulletin board using recycled corks.', 4.50, 1, 11, 5, 'images/Cork Bulletin Board.jpg'),
('Painted Stone Garden Marker', 'Garden markers painted on river stones.', 2.70, 1, 24, 14, 'images/Painted Stone Garden Marker.jpg'),
('LED Party Crown', 'Party crown that lights up with LEDs.', 3.95, 1, 18, 12, 'images/LED Party Crown.jpg'),
('Felt Christmas Ornament', 'Festive Christmas tree ornament from felt.', 2.10, 1, 20, 12, 'images/Felt Christmas Ornament.jpg');

-- Product_Tag: Gắn tag trực tiếp cho từng sản phẩm (ví dụ)
-- 1. Paper Flower Bouquet (id=1): cute(1), paper(13), spring(39)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (1, 1), (1, 13), (1, 39);

-- 2. DIY Robot Toy (id=2): tech(9), education(6), electronic(23)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (2, 9), (2, 6), (2, 23);

-- 3. Beaded Bracelet (id=3): recycled(5), minimalist(3), cute(1)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (3, 5), (3, 3), (3, 1);

-- 4. Origami Crane (id=4): paper(13), origami(11), spring(39)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (4, 13), (4, 11), (4, 39);

-- 5. LED Bookmark (id=5): led(19), modern(2)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (5, 19), (5, 2);

-- 6. DIY Clay Mini Pot (id=6): clay(18), paint(22)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (6, 18), (6, 22);

-- 7. Recycled Bottle Vase (id=7): recycled(5), glass(20), spring(39)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (7, 5), (7, 20), (7, 39);

-- 8. Cardboard Robot (id=8): cardboard(14), education(6), easy(26)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (8, 14), (8, 6), (8, 26);

-- 9. Mini Woven Basket (id=9): yarn(16), minimalist(3), cute(1)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (9, 16), (9, 3), (9, 1);

-- 10. Bottle Cap Magnet (id=10): recycled(5), art(7), modern(2)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (10, 5), (10, 7), (10, 2);

-- 11. Paper Lantern (id=11): paper(13), spring(39), easy(26)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (11, 13), (11, 39), (11, 26);

-- 12. DIY Wooden Bookmark (id=12): wood(12), minimalist(3), education(6)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (12, 12), (12, 3), (12, 6);

-- 13. Felt Flower Brooch (id=13): cute(1), fabric(15), art(7)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (13, 1), (13, 15), (13, 7);

-- 14. Mason Jar Vase (id=14): recycled(5), glass(20), spring(39)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (14, 5), (14, 20), (14, 39);

-- 15. Yarn Wrapped Letters (id=15): yarn(16), art(7), modern(2)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (15, 16), (15, 7), (15, 2);

-- 16. DIY Clay Fridge Magnet (id=16): clay(18), cute(1), art(7)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (16, 18), (16, 1), (16, 7);

-- 17. Cardboard Cat House (id=17): cardboard(14), animal(2), easy(26)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (17, 14), (17, 2), (17, 26);

-- 18. Painted Canvas Tote (id=18): paint(22), fabric(15), recycled(5)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (18, 22), (18, 15), (18, 5);

-- 19. Shell Wind Chime (id=19): nature(6), summer(38), minimalist(3)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (19, 6), (19, 38), (19, 3);

-- 20. DIY Dreamcatcher (id=20): yarn(16), boho(10), art(7)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (20, 16), (20, 10), (20, 7);

-- 21. Origami Gift Box (id=21): origami(11), paper(13), birthday(33)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (21, 11), (21, 13), (21, 33);

-- 22. Beaded Phone Charm (id=22): recycled(5), cute(1), modern(2)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (22, 5), (22, 1), (22, 2);

-- 23. Knitted Cup Cozy (id=23): yarn(16), winter(41), easy(26)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (23, 16), (23, 41), (23, 26);

-- 24. Foam Dinosaur Toy (id=24): foam(23), education(6), boy(42)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (24, 23), (24, 6), (24, 42);

-- 25. Cork Bulletin Board (id=25): recycled(5), easy(26), education(6)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (25, 5), (25, 26), (25, 6);

-- 26. Painted Stone Garden Marker (id=26): paint(22), spring(39), nature(6)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (26, 22), (26, 39), (26, 6);

-- 27. LED Party Crown (id=27): led(19), birthday(33), modern(2)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (27, 19), (27, 33), (27, 2);

-- 28. Felt Christmas Ornament (id=28): fabric(15), christmas(30), cute(1)
INSERT INTO Product_Tag (product_id, tag_id) VALUES (28, 15), (28, 30), (28, 1);


-- Bạn có thể tiếp tục thêm dữ liệu vào Product_Tag cho các sản phẩm còn lại tùy ý.

-- Cart
INSERT INTO Cart (user_id) VALUES (1), (2), (3);

-- Cart_Product
INSERT INTO Cart_Product (cart_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 5),
(3, 1, 1);

-- Các bảng khác giữ nguyên sample như ban đầu.


INSERT INTO Coupon (code, description, discount_value, is_percent, min_order_value, quantity, expired_at, max_usage_per_user)
VALUES 
('DIY10', '10% off all DIY orders over $50', 10.00, 1, 50.00, 100, '2025-12-31', 3),
('SAVE50', '$50 off orders over $200', 50.00, 0, 200.00, 50, '2025-10-01', 1),
('WELCOME20', '20% off for first-time customers', 20.00, 1, 0.00, 500, '2026-01-01', 1);

INSERT INTO User_Coupon (user_id, coupon_code, usage_count, used_at)
VALUES
-- User 1 đã được cấp mã DIY10 nhưng chưa dùng
(1, 'DIY10', 0, NULL),

-- User 2 đã dùng mã SAVE50 1 lần (đạt giới hạn 1)
(2, 'SAVE50', 0, GETDATE()),

-- User 3 đã được cấp mã WELCOME20 nhưng chưa dùng
(3, 'WELCOME20', 0, NULL);

INSERT INTO Coupon (code, description, discount_value, is_percent, min_order_value, quantity, expired_at, max_usage_per_user)
VALUES 
('DIY5USD', 'Get $5 OFF any order', 5.00, 0, 0.00, 50, DATEADD(day, 20, GETDATE()), 1),
('DIY10USD', 'Save $10 on orders over $50', 10.00, 0, 50.00, 40, DATEADD(day, 30, GETDATE()), 1),
('DIY10PCT', 'Enjoy 10% OFF on orders over $100', 10.00, 1, 100.00, 30, DATEADD(day, 30, GETDATE()), 1),
('DIY15PCT', '15% OFF orders above $150', 15.00, 1, 150.00, 25, DATEADD(day, 30, GETDATE()), 1),
('DIY25USD', '$25 OFF large orders over $200', 25.00, 0, 200.00, 20, DATEADD(day, 30, GETDATE()), 1),
('LUCKY50USD', 'Lucky draw! Get $50 OFF over $300', 50.00, 0, 300.00, 10, DATEADD(day, 45, GETDATE()), 1);


SELECT * FROM Coupon WHERE code = 'DIY10';

